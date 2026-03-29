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
    static func fetchEntry(urlString: String, configuration: MyNetworkWidgetConfigurationAppIntent) async throws -> NetworkWidgetProvider.WidgetTimelineEntry {
        let url = URL(string: urlString + "?deviceId=\(configuration.deviceId)")!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.timeoutInterval = 10

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        
        // Read raw response body as String
        let responseBody = String(data: data, encoding: .utf8) ?? ""
        
        SxWidetSharedCode.saveToSharedFile(widgetId: "netwidget1_small_network.xml", xml: responseBody)
        
        
        return NetworkWidgetProvider.WidgetTimelineEntry(
            date: Date.now,
                            configuration: configuration,
            family: WidgetFamily.systemSmall,
                            widgetPostFix: "network"
                        )
    }
}
