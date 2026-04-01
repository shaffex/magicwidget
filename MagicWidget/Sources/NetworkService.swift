//
//  NetworkService.swift
//  PluginWidgets
//
//  Created by Peter Popovec on 17/03/2026.
//

import Foundation
import WidgetKit

struct APIResponse: Decodable {
    let title: String
    let subtitle: String
    let value: String
}

actor NetworkRequestGate {
    static let shared = NetworkRequestGate()

    private struct CachedResult {
        let lastRequestAt: Date
        let xml: String
    }

    private var cachedResults: [String: CachedResult] = [:]
    private var inFlightRequests: [String: Task<NetworkWidgetProvider.WidgetTimelineEntry, Error>] = [:]
    private let minimumRequestInterval: TimeInterval = 2

    func cachedEntryIfFresh(
        for key: String,
        family: WidgetFamily,
        configuration: MyNetworkWidgetConfigurationAppIntent
    ) -> NetworkWidgetProvider.WidgetTimelineEntry? {
        guard let cachedResult = cachedResults[key] else {
            return nil
        }

        guard Date.now.timeIntervalSince(cachedResult.lastRequestAt) < minimumRequestInterval else {
            return nil
        }

        return NetworkWidgetProvider.WidgetTimelineEntry(
            date: .now,
            configuration: configuration,
            family: family,
            widgetPostFix: "network",
            xml: cachedResult.xml
        )
    }

    func inFlightRequest(for key: String) -> Task<NetworkWidgetProvider.WidgetTimelineEntry, Error>? {
        inFlightRequests[key]
    }

    func storeInFlightRequest(
        _ task: Task<NetworkWidgetProvider.WidgetTimelineEntry, Error>,
        for key: String
    ) {
        inFlightRequests[key] = task
    }

    func finishRequest(for key: String, xml: String) {
        cachedResults[key] = CachedResult(lastRequestAt: .now, xml: xml)
        inFlightRequests[key] = nil
    }

    func failRequest(for key: String) {
        inFlightRequests[key] = nil
    }
}

enum NetworkService {
    static func fetchEntry(urlString: String, family: WidgetFamily, configuration: MyNetworkWidgetConfigurationAppIntent) async throws -> NetworkWidgetProvider.WidgetTimelineEntry {
        let requestKey = "\(urlString)|\(family.rawValue)|\(configuration.deviceId)"
        if let cachedEntry = await NetworkRequestGate.shared.cachedEntryIfFresh(
            for: requestKey,
            family: family,
            configuration: configuration
        ) {
            print("NetworkService: cached response for \(requestKey)")
            return cachedEntry
        }

        if let existingTask = await NetworkRequestGate.shared.inFlightRequest(for: requestKey) {
            return try await existingTask.value
        }

        let task = Task<NetworkWidgetProvider.WidgetTimelineEntry, Error> {
            print("NetworkService: live request for \(requestKey)")
            if let url = URL(string: urlString + "?family=\(family.debugDescription)&deviceId=\(configuration.deviceId)") {
                var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
                request.timeoutInterval = 10
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                
                return buildEntry(
                    from: data,
                    family: family,
                    configuration: configuration
                )
            } else {
                let str = "<body><ellipse/></body>"
                let data = str.data(using: .utf8)!
                return buildEntry(
                    from: data,
                    family: family,
                    configuration: configuration
                )
            }
        }

        await NetworkRequestGate.shared.storeInFlightRequest(task, for: requestKey)

        do {
            let entry = try await task.value
            await NetworkRequestGate.shared.finishRequest(for: requestKey, xml: entry.xml)
            return entry
        } catch {
            await NetworkRequestGate.shared.failRequest(for: requestKey)
            throw error
        }
    }

    private static func buildEntry(
        from data: Data,
        family: WidgetFamily,
        configuration: MyNetworkWidgetConfigurationAppIntent
    ) -> NetworkWidgetProvider.WidgetTimelineEntry {
        let responseBody = String(data: data, encoding: .utf8) ?? ""
        let fileName = SxWidetSharedCode.getFileName(kind: "netwidget1", family: family, postFix: "network")
        let previousXML = SxWidetSharedCode.loadFromSharedFile(filename: fileName) ?? ""
        let xml = previousXML == responseBody ? previousXML : responseBody
        if xml == "" {
            print("kkc")
        }

        if previousXML != responseBody {
            SxWidetSharedCode.saveToSharedFile(widgetId: fileName, xml: responseBody)
        }
        
        
        return NetworkWidgetProvider.WidgetTimelineEntry(
            date: Date.now,
            configuration: configuration,
            family: family,
            widgetPostFix: "network",
            xml: xml
        )
    }
}
