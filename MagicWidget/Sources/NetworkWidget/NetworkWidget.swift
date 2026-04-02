//
//  NetworkWidget.swift
//  MagicWidget
//
//  Created by Peter Popovec on 02/04/2026.
//

import SwiftUI
import AppIntents
import WidgetKit

public struct MyNetworkWidget: Widget {
    let kind: String = "netwidget1"
    
    public static func performAction(_ action: String) {
        PluginActions.shared.runAction(action)
    }
    
    public init() {
        MagicUiView.installActionPlugin(name: "reloadAllTimelines", plugin: SxAction_reloadAllTimelines.self)
    }
    
    let xmlSnapshotView = """
        <body>
            <text>Snapshot MyNetworkWidget</text>
        </body>
        """
    
    public var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: MyNetworkWidgetConfigurationAppIntent.self, provider: NetworkWidgetProvider<MyNetworkWidgetConfigurationAppIntent>(xmlSnapshotView: xmlSnapshotView)) { entry in
            NetworkWidgetView(entry: entry, kind: kind)
                .containerBackground(.fill.tertiary, for: .widget)
                // must be there otherewise please adopt container background API will appear on widget
        }
        .configurationDisplayName("MyNetworkWidget Configuration")
        .description("You can configure this widget by clicking on Edit Widget")
        .supportedFamilies([.systemSmall, .systemMedium])
        .promptsForUserConfiguration()
    }
}
