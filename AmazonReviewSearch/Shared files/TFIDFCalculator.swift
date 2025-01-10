//
//  TFIDFCalculator.swift
//  AmazonReviewSearch
//
//  Created by Anastasia Mousa on 7/1/25.
//

import Foundation

struct TFIDFCalculator {
    
    private var idfCache: [String: Double] = [:]

    func calculateTFIDF(for review: [String: String], queryWords: [Substring]) -> Double {
        let text = (review["title"] ?? "") + " " + (review["text"] ?? "")
        let words = text.split(separator: " ").map { $0.lowercased() }
        
        var tf = [String: Double]()
        for word in words {
            tf[word, default: 0.0] += 1.0
        }

        for word in tf.keys {
            tf[word]! /= Double(words.count)
        }

        // calculating the TF-IDF
        return queryWords.reduce(0.0) { result, queryWord in
            let query = queryWord.lowercased()
            return result + (tf[query] ?? 0.0) * (idfCache[query] ?? 0.0)
        }
    }

    // calculating the IDF for the 1st appearance of the reviews' list 
    mutating func calculateIDF(from reviews: [[String: String]]) {
        var documentFrequency = [String: Int]()
        for review in reviews {
            let text = (review["title"] ?? "") + " " + (review["text"] ?? "")
            let words = Set(text.split(separator: " ").map { $0.lowercased() })
            for word in words {
                documentFrequency[word, default: 0] += 1
            }
        }

        for (word, count) in documentFrequency {
            idfCache[word] = log(Double(reviews.count) / (1 + Double(count)))
        }
    }
    
}
