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
    private var inFlightRequests: [String: Task<String, Error>] = [:]
    private let minimumRequestInterval: TimeInterval = 2

    func cachedXMLIfFresh(for key: String) -> String? {
        guard let cachedResult = cachedResults[key] else {
            return nil
        }

        guard Date.now.timeIntervalSince(cachedResult.lastRequestAt) < minimumRequestInterval else {
            return nil
        }

        return cachedResult.xml
    }

    func inFlightRequest(for key: String) -> Task<String, Error>? {
        inFlightRequests[key]
    }

    func storeInFlightRequest(_ task: Task<String, Error>, for key: String) {
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
    static func fetchEntry<Intent: MagicNetworkWidgetConfigurationIntent>(
        urlString: String,
        family: WidgetFamily,
        configuration: Intent
    ) async throws -> NetworkWidgetProvider<Intent>.WidgetTimelineEntry {
        let requestKey = "\(urlString)|\(family.rawValue)|\(configuration.deviceId)"
        if let cachedXML = await NetworkRequestGate.shared.cachedXMLIfFresh(for: requestKey) {
            print("NetworkService: cached response for \(requestKey)")
            return buildEntry(from: cachedXML, family: family, configuration: configuration)
        }

        if let existingTask = await NetworkRequestGate.shared.inFlightRequest(for: requestKey) {
            let xml = try await existingTask.value
            return buildEntry(from: xml, family: family, configuration: configuration)
        }

        let task = Task<String, Error> {
            print("NetworkService: live request for \(requestKey)")
            if let url = URL(string: urlString + "?family=\(family.debugDescription)&deviceId=\(configuration.deviceId)") {
                var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
                request.timeoutInterval = 10
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                
                return String(data: data, encoding: .utf8) ?? ""
            } else {
                return "<body><ellipse/></body>"
            }
        }

        await NetworkRequestGate.shared.storeInFlightRequest(task, for: requestKey)

        do {
            let xml = try await task.value
            await NetworkRequestGate.shared.finishRequest(for: requestKey, xml: xml)
            return buildEntry(from: xml, family: family, configuration: configuration)
        } catch {
            await NetworkRequestGate.shared.failRequest(for: requestKey)
            throw error
        }
    }

    private static func buildEntry<Intent: MagicNetworkWidgetConfigurationIntent>(
        from responseBody: String,
        family: WidgetFamily,
        configuration: Intent
    ) -> NetworkWidgetProvider<Intent>.WidgetTimelineEntry {
        let fileName = SxWidetSharedCode.getFileName(kind: "netwidget1", family: family, postFix: "network")
        let previousXML = SxWidetSharedCode.loadFromSharedFile(filename: fileName) ?? ""
        let xml = previousXML == responseBody ? previousXML : responseBody
        if xml == "" {
            print("kkc")
        }

        if previousXML != responseBody {
            SxWidetSharedCode.saveToSharedFile(widgetId: fileName, xml: responseBody)
        }
        
        
        return NetworkWidgetProvider<Intent>.WidgetTimelineEntry(
            date: Date.now,
            configuration: configuration,
            family: family,
            widgetPostFix: "network",
            xml: xml
        )
    }
}
