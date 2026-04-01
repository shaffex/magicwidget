//
//  MyWidgetEntryView.swift
//  MyWidget
//
//  Created by Peter Popovec on 13/03/2026.
//

import WidgetKit
import SwiftUI
import MagicUiFramework


struct KokoceCongig {
    static let xmlPlaceholder = """
        <body>
            <text>Placeholder XML</text>
        </body>
        """
    
    static let xmlSnapshot = """
        <body>
            <text>Snapshot XML</text>
        </body>
        """
}


struct MyNetworkWidgetEntryView : View {
    var entry: NetworkWidgetProvider.Entry
    let kind: String
    
    var body: some View {
        MagicUiWidgetView(string: entry.xml)
            .widgetURL(URL(string: kind)!)
    }
}
