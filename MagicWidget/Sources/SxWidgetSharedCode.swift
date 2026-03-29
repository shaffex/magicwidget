//
//  SxWidgetSharedCode.swift
//  Barcoder
//
//  Created by Peter Popovec on 05/08/2025.
//

import Foundation
import WidgetKit
import MagicUiFramework

struct SxWidetSharedCode {
    static let appGroupId = "group.com.shaffex.mywidget"
    
    
    
    static func getFileName(kind: String, family: WidgetFamily, postFix: String) -> String {
        let familyString: String
        switch family {
        case .systemSmall:
            familyString = "small"
        case .systemMedium:
            familyString = "medium"
        case .systemLarge:
            familyString = "large"
        case .systemExtraLarge:
            familyString = "extraLarge"
        default:
            familyString = "unknown"
        }
        return "\(kind)_\(familyString)_\(postFix).xml"
    }
    
    static func saveToSharedFile2(widgetId: String, xml: String) {
        let filename = widgetId
        
        guard let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: SxWidetSharedCode.appGroupId)?
            .appendingPathComponent(filename) else {
            return
        }

        do {
            try xml.write(to: url, atomically: true, encoding: .utf8)
            print("✅ XML saved to shared file: \(filename)")
        } catch {
            print("❌ Failed to save XML: \(error)")
        }
        
        // save to documents too as first one is saved to app groups
        SxFile.writeTextFile(fileURL: SxFile.documentsDir(filename), text: xml)
    }
    
    static func loadFromSharedFile2(filename: String) -> String? {
        print(("loadFromSharedFile \(filename)"))
        guard let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: SxWidetSharedCode.appGroupId)?
            .appendingPathComponent(filename) else {
            return nil
        }

        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("❌ Failed to load XML: \(error)")
            return nil
        }
    }
    
    static func reloadAllWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    
    
    
    static func saveToSharedFile(widgetId: String, xml: String) {
        let filename = widgetId
        
        SxFile.writeTextFile(fileURL: SxFile.documentsDir(filename), text: xml)
    }
    
    static func loadFromSharedFile(filename: String) -> String? {
        SxFile.readTextFile(fileURL: SxFile.documentsDir(filename))
    }
}

