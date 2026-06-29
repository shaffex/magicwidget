//
//  SxFile.swift
//  ShaffexAPI
//
//  Created by Peter Popovec on 27/10/2021.
//

import Foundation

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

//    var fileSize: UInt64? {
//        return attributes?[.size] as? UInt64
//    }
    
    public var fileSize: Int? {
        return attributes?[.size] as? Int
    }

    public var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize!), countStyle: .file)
    }

    public var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
    
    public var fileExists: Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    public var type: String? {
        return attributes?[.ownerAccountName] as? String
    }
    
    public var permissions: Int? {
        return attributes?[.posixPermissions] as? Int
    }
}

public struct SxFile {
    
    public static var homeDirectory = URL(fileURLWithPath: NSHomeDirectory())
    public static var documentsDirectory = getDocumentsDirectoryPath()
    public static var applicationSupportDirectoryPath = getApplicationSupportDirectoryPath()
    
    static func getDocumentsDirectoryPath() -> URL {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            return URL(fileURLWithPath: path!)
    }
    
    static func getApplicationSupportDirectoryPath() -> URL {
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first
            return URL(fileURLWithPath: path!)
    }
    
    public static func documentsDir(_ filename: String) -> URL {
#if os(macOS)
        return MagicUiDirs.macOsDocumentsDir.appendingPathComponent(filename)
#else
    return documentsDirectory.appendingPathComponent(filename)
#endif
    }

    public func getFileContent(fileURL: URL) -> Data? {
        return FileManager.default.contents(atPath: fileURL.absoluteString)
    }
    
    public static func getContentsOfDirectory(at fileURL: URL) throws -> [URL] {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: nil)
            print(directoryContents)
            return directoryContents

        } catch {
            print(error)
            throw error
        }
    }
    
    public static func createDirectory(fileUrl: URL, dirName: String, withIntermediateDirectories: Bool = false) throws {
        
        do {
            try FileManager.default.createDirectory(at: fileUrl.appendingPathComponent(dirName), withIntermediateDirectories: withIntermediateDirectories)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
    
    public static func createFile(fileURL: URL) {
        writeTextFile(fileURL: fileURL, text: "")
    }
    
    public static func createFileIfNotExists(fileURL: URL) {
        if !fileURL.fileExists {
            writeTextFile(fileURL: fileURL, text: "")
        }
    }
    
    public static func deleteFile(fileURL: URL) throws {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
            throw error
        }
    }
    
    // MARK: read from resource file
    
    public static func readTextResourceFile(filename: String, ofType: String) -> String? {
            
        if let fileUrl = Bundle.main.path(forResource: filename, ofType: ofType) {
            do {
                let contents = try String(contentsOfFile: fileUrl)
                return contents
                
            } catch {
                // contents could not be loaded
                print("ERROR: \(error.localizedDescription)")
            }
        } else {
            print("Resource file \(filename).\(ofType) not found!!!")
            return nil
        }
        
        return nil
    }
    
    public static func readResourceFile(filename: String, ofType: String) -> Data? {
            
        if let fileUrl = Bundle.main.url(forResource: filename, withExtension: ofType) {
            do {
                let contents = try Data(contentsOf: fileUrl )
                return contents
            }
            catch {
                // contents could not be loaded
                print("ERROR: \(error.localizedDescription)")
            }
        } else {
            print("Resource file \(filename).\(ofType) not found!!!")
            return nil
        }
        
        return nil
    }
    
    // MARK: reading from file

    public static func readFile(fileURL: URL) -> Data? {

        do {
            return try Data(contentsOf: fileURL)
        } catch {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            return nil
        }
    }
    
    public static func readTextFile(fileURL: URL) -> String? {

        do {
            return try String(contentsOf: fileURL)
        } catch {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            return nil
        }
    }
    
//    public static func readTextFile(fileURL: URL) async -> String? {
//        await withCheckedContinuation { continuation in
//            DispatchQueue.global(qos: .userInitiated).async {
//                do {
//                    let text = try String(contentsOf: fileURL)
//                    continuation.resume(returning: text)
//                } catch {
//                    print("❌ Failed reading from \(fileURL): \(error.localizedDescription)")
//                    continuation.resume(returning: nil)
//                }
//            }
//        }
//    }
    
    // MARK: writing to file
    
    public static func writeTextFile(fileURL: URL, text: String, appendMode: Bool = false) {
        let data = Data(text.utf8)
        writeFile(fileURL: fileURL, data: data, appendMode: appendMode)
    }
    
//    public static func writeTextFile(fileURL: URL, text: String, appendMode: Bool = false) async {
//        let data = Data(text.utf8)
//        
//        await withCheckedContinuation { continuation in
//            DispatchQueue.global(qos: .utility).async {
//                writeFile(fileURL: fileURL, data: data, appendMode: appendMode)
//                continuation.resume()
//            }
//        }
//    }
    
    public static func writeFile(fileURL: URL, data: Data, appendMode: Bool = false) {
        
        // if there is no append mode, delete existing file if any
        if (appendMode == false) {
            //try? FileManager.default.removeItem(at: fileURL)
            try? data.write(to: fileURL)
            return
        }
        
        // if append mode
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
             fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
        } else {
            // if file not exists, will try to create it
            try? data.write(to: fileURL)
        }
 
    }
    
    public static func fileExists(fileURL: URL) -> Bool {
        return fileURL.fileExists
    }
    

}
