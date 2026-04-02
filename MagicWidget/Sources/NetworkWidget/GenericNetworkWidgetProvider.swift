//
//  GenericNetworkWidgetProvider.swift
//  MagicWidget
//
//  Created by Codex on 02/04/2026.
//

import MagicWidget

typealias NetworkWidgetIntentValues = MagicNetworkWidgetConfigurationIntent
public typealias GenericNetworkWidgetProvider<ConfigurationIntent: MagicNetworkWidgetConfigurationIntent> = NetworkWidgetProvider<ConfigurationIntent>
