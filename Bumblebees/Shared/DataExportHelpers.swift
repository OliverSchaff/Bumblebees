//
//  DataExportHelpers.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 22.07.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import Foundation

class DataExportHelpers {
    
    static var dateFormatterWithMilliseconds: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss.SSS"
        return df
    }()
    static var dateFormatterForFileName: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd"
        return df
    }()

    
    static func generateFileURLForBaseString(_ name: String, withExtension ext: String) throws -> URL {
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let dateString = dateFormatterForFileName.string(from: Date())
        func urlForIndex(_ index: Int) -> URL {
            let fileURL = documentDirectory.appendingPathComponent(name + "-" + dateString + "-" + String(index) + "." + ext )
            if fileManager.fileExists(atPath: fileURL.path) {
                let newIndex = index + 1
                return urlForIndex(newIndex)
            } else {
                return fileURL
            }
        }
        return urlForIndex(1)
    }
    
    static func exportArray<T: Encodable>(array: [T], to fileURL: URL, callback: (Result<Bool>)->()) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(DataExportHelpers.dateFormatterWithMilliseconds)
        do {
            
            let jsonData = try jsonEncoder.encode(array)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
            do {
                try jsonData.write(to: fileURL, options: .withoutOverwriting)
                
                // here is a nice converter to csv: https://json-csv.com
                // use the "header / detail report style" for nicest representation
                
                callback(Result.success(true))
            } catch {
                callback(Result.error("writing file failed"))
            }
        } catch {
            callback(Result.error("JSON encoding failed"))
        }
    }
}
