//
//  NetworkWidgetConfigurationIntent.swift
//  MagicWidget
//
//  Created by Peter Popovec on 02/04/2026.
//

import WidgetKit
import AppIntents

public struct MyNetworkWidgetConfigurationAppIntent: MagicNetworkWidgetConfigurationIntent {
    public static var title: LocalizedStringResource = "Configuration KKC"

    public init() {}

    @Parameter(title: "Device ID", default: "Kocur")
    public var deviceId: String
    
    @Parameter(title: "Refresh Interval (min)", default: 30)
    public var refreshInterval: Int

//    @Parameter(
//        title: "Widget URL",
//        requestValueDialog: IntentDialog("Enter the widget url")
//    )
//    var widgetURL: String?
    
    @Parameter(title: "Widget URL", default: "https://magic-ui.com/Skusky/Widgets/networkTest.php")
    public var widgetURL: String?
}
