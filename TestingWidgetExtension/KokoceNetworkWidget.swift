//
//  KokoceNetworkWidget.swift
//  MagicWidget
//
//  Created by Peter Popovec on 02/04/2026.
//

import SwiftUI
import WidgetKit
import AppIntents
import MagicWidget

struct KokoceNetworkWidget: Widget {
    let kind: String = "KokoceNetworkWidget"

    private static let xmlSnapshotView = """
        <body>
            <text>Snapshot Kokoce</text>
        </body>
        """
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: KokoceNetworkWidgetIntent.self,
            provider: GenericNetworkWidgetProvider<KokoceNetworkWidgetIntent>(xmlSnapshotView: Self.xmlSnapshotView)
        ) { entry in
            NetworkWidgetView(entry: entry, kind: kind)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("KokoceNetworkWidget Configuration")
        .description("Configurable network widget")
        .supportedFamilies([.systemSmall, .systemMedium])
        .promptsForUserConfiguration()
    }
}

// Each widget kind must have its own distinct AppIntent type so WidgetKit can
// associate the "Edit Widget" configuration with the correct widget.
struct KokoceNetworkWidgetIntent: MagicNetworkWidgetConfigurationIntent {
    static var title: LocalizedStringResource = "MyNetworkWidget Configuration"

    @Parameter(title: "Device ID", default: "CustomKokoce")
    var deviceId: String

    @Parameter(title: "Refresh Interval (min)", default: 30)
    var refreshInterval: Int

    @Parameter(title: "Widget URL", default: "https://magic-ui.com/Skusky/Widgets/myCustomNetworkWidget.xml")
    var widgetURL: String?
}
