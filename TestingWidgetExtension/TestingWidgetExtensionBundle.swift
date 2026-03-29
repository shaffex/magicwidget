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
struct TestingWidgetExtensionBundle: WidgetBundle {//}, AppIntentsPackage {
//    static var includedPackages: [any AppIntentsPackage.Type] {
//        [MagicWidgetAppIntents.self]
//    }

    var body: some Widget {
        MyNetworkWidget()
    }
}
