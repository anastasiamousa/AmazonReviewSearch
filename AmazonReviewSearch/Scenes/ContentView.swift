//
//  ContentView.swift
//  AmazonReviewSearch
//
//  Created by Anastasia Mousa on 7/1/25.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    //MARK: - Properties
    
    @State private var reviewData: [[String: String]] = []
    @State private var searchQuery: String = ""
    @State private var polarityFilter: String = "All"
    @State private var pageIndex: Int = 0
    @State private var isSearching: Bool = false
    @State private var sortOption: String = "Relevance"
    @State private var resultsPerPage: Int = 10

    private let sortOptions = ["Relevance", "Title", "Polarity"]

    @State var tfidfCalculator = TFIDFCalculator()
    private var reviewFilter = ReviewsFeedManager()
    private var statisticsCalculator = DatasetStatisticsCalculator()
    
    // filter & sorting
    var processedReviews: [[String: String]] {
        let polarityFiltered = reviewFilter.filterReviews(byPolarity: reviewData, selectedPolarity: polarityFilter)

        if searchQuery.isEmpty {
            return reviewFilter.sortReviews(polarityFiltered, by: sortOption)
        } else {
            let queryWords = searchQuery.split(separator: " ")
            var scoredReviews = polarityFiltered.map { review in
                (review, tfidfCalculator.calculateTFIDF(for: review, queryWords: queryWords))
            }

            scoredReviews.sort { $0.1 > $1.1 }
            return reviewFilter.sortReviews(scoredReviews.map { $0.0 }, by: sortOption)
        }
    }

    // reviews in pages
    var visibleReviews: [[String: String]] {
        reviewFilter.paginateReviews(processedReviews, currentPage: pageIndex, resultsPerPage: resultsPerPage)
    }

    // statistics
    private var totalWords: Int {
        statisticsCalculator.calculateTotalWords(in: reviewData)
    }

    // top words in reviews
    private var topWords: [(String, Int)] {
        statisticsCalculator.calculateTopWords(in: reviewData, limit: 5)
    }

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(" Amazon Review Dataset Stats")
                        .font(.headline)

                    Text("Total Documents: \(reviewData.count)")
                    Text("Total Words: \(totalWords)")

                    Text("Top Words:")
                    ForEach(topWords, id: \.0) { word, count in
                        Text("\(word): \(count) occurrences")
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
                .padding(.trailing)

                VStack {
                    TextField("Type a keyword to search...", text: $searchQuery, onCommit: {
                        isSearching = true
                        pageIndex = 0
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)

                    Picker("Polarity", selection: $polarityFilter) {
                        Text("All").tag("All")
                        Text("Positive").tag("Positive")
                        Text("Negative").tag("Negative")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom)

                    Picker("Sort by", selection: $sortOption) {
                        ForEach(sortOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }

            List(visibleReviews.enumerated().map { (index, review) in (review, tfidfCalculator.calculateTFIDF(for: review, queryWords: searchQuery.split(separator: " "))) }, id: \.0) { (review, score) in
                VStack(alignment: .leading, spacing: 5) {
                    Text("Polarity: \(review["polarity"] ?? "N/A")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Relevance: \(String(format: "%.3f", score))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(review["title"] ?? "No Title")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text(review["text"] ?? "No Text")
                        .font(.subheadline)
                        .lineLimit(2)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 2)
            }

            HStack {
                Stepper("Results per page: \(resultsPerPage)", value: $resultsPerPage, in: 5...50, step: 5)
                    .padding(.bottom)
                Button("Previous") {
                    if pageIndex > 0 {
                        pageIndex -= 1
                    }
                }
                .disabled(pageIndex == 0)

                Spacer()

                Button("Next") {
                    if (pageIndex + 1) * resultsPerPage < processedReviews.count {
                        pageIndex += 1
                    }
                }
                .disabled((pageIndex + 1) * resultsPerPage >= processedReviews.count)
            }
            .padding()
        }
        .navigationTitle("Amazon Reviews")
        .onAppear {
            DispatchQueue.global(qos: .userInitiated).async {
                self.reviewData = CSVLoader.loadCSV(fileName: "AmazonReviewsDataset")
                tfidfCalculator.calculateIDF(from: reviewData)
            }
        }
    }
}

struct ContentViewPreview: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
    
}
