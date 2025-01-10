//
//  CSVFileLoader.swift
//  AmazonReviewSearch
//
//  Created by Anastasia Mousa on 7/1/25.
//

import Foundation
import SwiftCSV

class CSVLoader {
    
    static func loadCSV(fileName: String) -> [[String: String]] {
        
        do {
            if let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") {
                let csvFile = try NamedCSV(url: URL(fileURLWithPath: filePath))
                return csvFile.rows // data as an array of dictionaries
            } else {
                print("File \(fileName).csv not found.")
            }
        } catch {
            print("Error loading CSV file: \(error)")
        }
        
        return []
    }
    
}
