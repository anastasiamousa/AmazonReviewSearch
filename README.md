# AmazonReviewSearch

A macOS application built with SwiftUI for searching and analyzing Amazon products' reviews. The project uses the [Amazon Reviews Dataset](https://www.kaggle.com/datasets/kritanjalijain/amazon-reviews) from Kaggle.

---

## Features

1. **Search Functionality**:  
   Search Amazon reviews by keywords, using a fast and accurate text search.

2. **Filter by Polarity**:  
   Filter reviews based on their sentiment polarity (Positive, Negative, or All).

3. **Sorting Options**:  
   Sort reviews by relevance (TF-IDF), title, or polarity.

4. **Pagination**:  
   View reviews with customizable pagination (results per page).

5. **Statistics Overview**:  
   - Total number of reviews.
   - Total number of words in all reviews.
   - Top 5 most frequently used words.

---

## Technologies Used

- **SwiftUI**: For building the user interface.
- **Swift**: For logic and data processing.
- **Kaggle Dataset**: Amazon Reviews Dataset for real-world data.
- **TF-IDF Algorithm**: For calculating relevance of search queries.

---

## How It Works

1. **Data Loading**:  
   The app uses `SwiftCSV` to parse and load the dataset.

2. **TF-IDF Calculation**:  
   The relevance of each review is calculated based on query words and term frequencies using a custom `TFIDFCalculator`.

3. **Filtering and Sorting**:  
   The app allows filtering reviews by polarity and sorting by different criteria.

4. **Statistics**:  
   The app calculates and displays important statistics such as top words and document counts.

---

## How to Run

1. Clone this repository:
   ```bash
   git clone https://github.com/anastasiamousa/AmazonReviewSearch.git

2. Open the .xcodeproj file in Xcode.

3. Build and run the app.
