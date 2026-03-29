//
//  MyWidgetEntryView.swift
//  MyWidget
//
//  Created by Peter Popovec on 13/03/2026.
//

import WidgetKit
import SwiftUI
import MagicUiFramework

struct MyNetworkWidgetEntryView : View {
    var entry: NetworkWidgetProvider.Entry
    let kind: String

    var body: some View {
//        Text(entry.widgetPostFix)
        
        
        MagicUiWidgetView(string: SxWidetSharedCode.loadFromSharedFile(filename: SxWidetSharedCode.getFileName(kind: kind, family: entry.family, postFix: entry.widgetPostFix)) ?? "")
            .widgetURL(URL(string: kind)!)
    }
}
