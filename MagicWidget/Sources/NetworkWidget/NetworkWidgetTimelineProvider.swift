//
//  NetworkWidgetTimelineProvider.swift
//  MagicWidget
//
//  Created by Peter Popovec on 02/04/2026.
//

import WidgetKit
import AppIntents

public struct NetworkWidgetProvider<Intent: MagicNetworkWidgetConfigurationIntent>: AppIntentTimelineProvider {
    
    var xmlSnapshotView: String
    
    public struct WidgetTimelineEntry: TimelineEntry {
        public let date: Date
        let configuration: Intent
        let family: WidgetFamily
        let widgetPostFix: String
        let xml: String
    }

    public init (xmlSnapshotView: String = "<body><text>Snapshot XML</text></body>") {
        self.xmlSnapshotView = xmlSnapshotView
    }
    
    public func placeholder(in context: Context) -> WidgetTimelineEntry {
        return WidgetTimelineEntry(date: Date(), configuration: Intent(), family: context.family, widgetPostFix: "placeholder", xml: xmlSnapshotView)
    }

    public func snapshot(for configuration: Intent, in context: Context) async -> WidgetTimelineEntry {
        WidgetTimelineEntry(date: Date(), configuration: configuration, family: context.family, widgetPostFix: "snapshot", xml: xmlSnapshotView)
    }
    
    // Called by the system to build the real timeline
    public func timeline(for configuration: Intent, in context: Context) async -> Timeline<WidgetTimelineEntry> {
        
        let refreshInterval = configuration.refreshInterval
        guard let widgetURL = configuration.widgetURL else {
            return Timeline(entries: [], policy: .never)
        }
        
        print("timeline: $refreshInterval: \(refreshInterval) family: \(context.family), widgetURL: \(configuration.widgetURL!)")
        
        do {
            let entry = try await NetworkService.fetchEntry(urlString: widgetURL, family: context.family, configuration: configuration)
            let nextRefresh = Calendar.current.date(byAdding: .minute, value: refreshInterval, to: .now)!
            return Timeline(entries: [entry], policy: .after(nextRefresh))
        } catch {
            print("kokoce try tetry")
            let retry = Calendar.current.date(byAdding: .minute, value: 5, to: .now)!
            return Timeline(entries: [], policy: .after(retry))
        }
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}
