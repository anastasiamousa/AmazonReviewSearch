//
//  ReviewsFeedManager.swift
//  AmazonReviewSearch
//
//  Created by Anastasia Mousa on 7/1/25.
//

import Foundation

struct ReviewsFeedManager {
    
    func filterReviews(byPolarity reviews: [[String: String]], selectedPolarity: String) -> [[String: String]] {
        guard selectedPolarity != "All" else { return reviews }
        return reviews.filter {
            $0["polarity"] == (selectedPolarity == "Positive" ? "2" : "1")
        }
    }

    func sortReviews(_ reviews: [[String: String]], by sortOption: String) -> [[String: String]] {
        switch sortOption {
        case "Title":
            return reviews.sorted { ($0["title"] ?? "") < ($1["title"] ?? "") }
        case "Polarity":
            return reviews.sorted { ($0["polarity"] ?? "") > ($1["polarity"] ?? "") }
        default:
            return reviews 
        }
    }

    func paginateReviews(_ reviews: [[String: String]], currentPage: Int, resultsPerPage: Int) -> [[String: String]] {
        let startIndex = currentPage * resultsPerPage
        let endIndex = min(startIndex + resultsPerPage, reviews.count)
        return Array(reviews[startIndex..<endIndex])
    }
    
}
