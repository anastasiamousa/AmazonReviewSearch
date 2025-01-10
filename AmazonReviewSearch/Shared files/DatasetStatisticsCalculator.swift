//
//  DatasetStatisticsCalculator.swift
//  AmazonReviewSearch
//
//  Created by Anastasia Mousa on 7/1/25.
//

import Foundation

struct DatasetStatisticsCalculator {
    
    func calculateTotalWords(in reviews: [[String: String]]) -> Int {
        reviews.reduce(0) {
            $0 + (($1["title"] ?? "") + " " + ($1["text"] ?? "")).split(separator: " ").count
        }
    }

    func calculateTopWords(in reviews: [[String: String]], limit: Int = 5) -> [(String, Int)] {
        let wordFrequency = reviews.reduce(into: [String: Int]()) { result, review in
            let words = ((review["title"] ?? "") + " " + (review["text"] ?? "")).split(separator: " ").map { $0.lowercased() }
            for word in words {
                result[word, default: 0] += 1
            }
        }
        return wordFrequency.sorted { $0.value > $1.value }.prefix(limit).map { $0 }
    }
    
}
