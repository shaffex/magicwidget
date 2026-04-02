//
//  MyCustomNetworkWidget.swift
//  MagicWidget
//
//  Created by Peter Popovec on 02/04/2026.
//

import SwiftUI
import WidgetKit
import AppIntents
import MagicWidget

struct MyCustomNetworkWidget: Widget {
    let kind: String = "MyCustomNetworkWidget"

    private static let xmlSnapshotView = """
        <body>
            <text>Snapshot Janka</text>
        </body>
        """
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: MyCustomNetworkWidgetIntent.self,
            provider: GenericNetworkWidgetProvider<MyCustomNetworkWidgetIntent>(xmlSnapshotView: Self.xmlSnapshotView)
        ) { entry in
            NetworkWidgetView(entry: entry, kind: kind)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("MyCustomNetworkWidget")
        .description("Configurable network widget")
        .supportedFamilies([.systemSmall, .systemMedium])
        .promptsForUserConfiguration()
    }
}

// Each widget kind must have its own distinct AppIntent type so WidgetKit can
// associate the "Edit Widget" configuration with the correct widget.
struct MyCustomNetworkWidgetIntent: MagicNetworkWidgetConfigurationIntent {
    static var title: LocalizedStringResource = "MyCustomWidget Configuration"

    @Parameter(title: "Device ID", default: "CustomKocur")
    var deviceId: String

    @Parameter(title: "Refresh Interval (min)", default: 30)
    var refreshInterval: Int

    @Parameter(title: "Widget URL", default: "https://magic-ui.com/Skusky/Widgets/myCustomNetworkWidget.xml")
    var widgetURL: String?
}

// Only if we need custom draw, otherwise use NetworkWidgetView in AppIntentConfiguration
//public struct MyCustomNetworkWidgetView : View {
//    var entry: NetworkWidgetProvider<MyCustomNetworkWidgetIntent>.WidgetTimelineEntry
//    let kind: String
//    
//    public init(entry: NetworkWidgetProvider<MyCustomNetworkWidgetIntent>.WidgetTimelineEntry, kind: String) {
//        self.entry = entry
//        self.kind = kind
//    }
//    
//    public var body: some View {
//        Circle().foregroundStyle(.brown)
//    }
//}
