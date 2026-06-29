//
//  NetworkWidgetView.swift
//  MagicWidget
//
//  Created by Peter Popovec on 02/04/2026.
//

import WidgetKit
import SwiftUI
import MagicUI

public struct NetworkWidgetView<Intent: MagicNetworkWidgetConfigurationIntent> : View {
    var entry: NetworkWidgetProvider<Intent>.WidgetTimelineEntry
    let kind: String
    
    public init(entry: NetworkWidgetProvider<Intent>.WidgetTimelineEntry, kind: String) {
        self.entry = entry
        self.kind = kind
    }
    
    public var body: some View {
//        MagicUiWidgetView(string: entry.xml)
//            .widgetURL(URL(string: kind)!)
        MagicUiView(string: entry.xml)
            .widgetURL(URL(string: kind)!)
    }
}
