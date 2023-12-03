//
//  BookAPI.swift
//  Books2Love
//
//  Created by Alicia Yang on 11/20/23.
//  Calls the Google Books API and returns books and lightnovels

import Foundation

struct BooksAPI {
        
    static let shared = BooksAPI()
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: gets a list of popular Young Adult Books from Google Books
    func popularBooksWest() async throws -> [Book] {
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=bestseller+YA+2023")!
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await urlSession.data(for: urlRequest)
        
        let items = try JSONDecoder().decode(GoogleBookResponse.self, from: data)
        let bookInfo = items.items
        return bookInfo
    }
    
    // MARK: gets 10 lightnovels from Google Books
    func lightNovels() async throws -> [Book] {
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=light+novels+2023")!
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await urlSession.data(for: urlRequest)
        
        let items = try JSONDecoder().decode(GoogleBookResponse.self, from: data)
        let bookInfo = items.items
        return bookInfo
    }
    
}

// format to decode the API response from Google Book's  API
// Adapted from: https://stackoverflow.com/questions/70645037/no-value-associated-with-key-codingkeys-error
struct Book: Codable {
    let volumeInfo: VolumeInfo
    let searchInfo: SearchInfo?
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let categories: [String]?
    let imageLinks: ImageLinks?
}

struct SearchInfo: Codable {
    let textSnippet: String
}

struct ImageLinks: Codable {
    let thumbnail: String
}

struct GoogleBookResponse: Codable {
    let items: [Book]
}

// MARK: Errors

enum BookAPIError: Error {
    case requestFailed(message: String)
}
