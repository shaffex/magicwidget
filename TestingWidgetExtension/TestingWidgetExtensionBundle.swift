//
//  TestingWidgetExtensionBundle.swift
//  TestingWidgetExtension
//
//  Created by Peter Popovec on 29/03/2026.
//

import WidgetKit
import AppIntents
import SwiftUI

import MagicWidget


@main
struct TestingWidgetExtensionBundle: WidgetBundle, AppIntentsPackage {
    //MARK: This is important — it is declared in MagicWidget framework and must be referenced from the widget extension in order for button intent to work
    static var includedPackages: [any AppIntentsPackage.Type] {
        [MyFrameworkAppIntents.self]
    }
    
    var body: some Widget {
//        MyNetworkWidget()
        KokoceNetworkWidget()
        MyCustomNetworkWidget()
    }
}
