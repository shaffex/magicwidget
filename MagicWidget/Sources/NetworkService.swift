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

enum NetworkService {
    static func fetchEntry(urlString: String, family: WidgetFamily, configuration: MyNetworkWidgetConfigurationAppIntent) async throws -> NetworkWidgetProvider.WidgetTimelineEntry {
        let url = URL(string: urlString + "?family=\(family.debugDescription)&deviceId=\(configuration.deviceId)")!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.timeoutInterval = 10

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        
        // Read raw response body as String
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
