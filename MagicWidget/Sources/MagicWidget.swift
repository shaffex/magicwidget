//
//  MagicWidget.swift
//  MagicWidget
//
//  Created by Peter Popovec on 29/03/2026.
//

import WidgetKit
import AppIntents
import SwiftUI
import MagicUiFramework

public struct MagicWidgetAppIntents: AppIntentsPackage {
    public init() {
    }
    
    public static var includedPackages: [any AppIntentsPackage.Type] {
        [MyFrameworkAppIntents.self]
    }
}

public struct MyNetworkWidget: Widget {
    let kind: String = "netwidget1"
    
    public static func performAction(_ action: String) {
        PluginActions.shared.runAction(action)
    }
    
    public init() {
        MagicUiView.installActionPlugin(name: "reloadAllTimelines", plugin: SxAction_reloadAllTimelines.self)
    }
    
    public var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: MyNetworkWidgetConfigurationAppIntent.self, provider: NetworkWidgetProvider()) { entry in
            MyNetworkWidgetEntryView(entry: entry, kind: kind)
                .containerBackground(.fill.tertiary, for: .widget)
                // must be there otherewise please adopt container background API will appear on widget
        }
        .configurationDisplayName("KI kkc3 Network Widget 1")
        .description("You can configure this widget by clicking on Edit Widget")
        .supportedFamilies([.systemSmall, .systemMedium])
        .promptsForUserConfiguration()
    }
}

struct NetworkWidgetProvider: AppIntentTimelineProvider {
    
    struct WidgetTimelineEntry: TimelineEntry {
        let date: Date
        let configuration: MyNetworkWidgetConfigurationAppIntent
        let family: WidgetFamily
        let widgetPostFix: String
        let xml: String
    }

    func placeholder(in context: Context) -> WidgetTimelineEntry {
        return WidgetTimelineEntry(date: Date(), configuration: MyNetworkWidgetConfigurationAppIntent(), family: context.family, widgetPostFix: "placeholder", xml: KokoceCongig.xmlPlaceholder)
    }

    func snapshot(for configuration: MyNetworkWidgetConfigurationAppIntent, in context: Context) async -> WidgetTimelineEntry {
        WidgetTimelineEntry(date: Date(), configuration: configuration, family: context.family, widgetPostFix: "snapshot", xml: KokoceCongig.xmlSnapshot)
    }
    
    // Called by the system to build the real timeline
    func timeline(for configuration: MyNetworkWidgetConfigurationAppIntent, in context: Context) async -> Timeline<WidgetTimelineEntry> {
        
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

public struct MyNetworkWidgetConfigurationAppIntent: WidgetConfigurationIntent {
    public static var title: LocalizedStringResource = "Configuration KKC"

    public init() {}

    @Parameter(title: "Device ID", default: "Kocur")
    var deviceId: String
    
    @Parameter(title: "Refresh Interval (min)", default: 30)
    var refreshInterval: Int

//    @Parameter(
//        title: "Widget URL",
//        requestValueDialog: IntentDialog("Enter the widget url")
//    )
//    var widgetURL: String?
    
    @Parameter(title: "Widget URL", default: "https://magic-ui.com/Skusky/Widgets/networkTest.php")
    var widgetURL: String?
}
