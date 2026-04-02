//
//  MagicWidget.swift
//  MagicWidget
//
//  Created by Peter Popovec on 29/03/2026.
//

import WidgetKit
//import AppIntents
import SwiftUI
import MagicUiFramework

// inside MagicWidget
@_exported import MagicUiFramework
@_exported import AppIntents

public protocol MagicNetworkWidgetConfigurationIntent: WidgetConfigurationIntent {
    init()

    var deviceId: String { get set }
    var refreshInterval: Int { get set }
    var widgetURL: String? { get set }
}
