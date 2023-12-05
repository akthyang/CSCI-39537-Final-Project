//
//  MangaAPI.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/4/23.
//  MARK: Calls MangaAPI from Kitsu API

import Foundation

import Foundation

struct MangaAPI {
        
    static let shared = MangaAPI()
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: gets a list of popular Young Adult Books from Google Books
    func getManga() async throws -> [Manga] {
        let items = try await callMangaAPI(url: "https://kitsu.io/api/edge/manga?page[limit]=10&page[offset]=0")
        let mangaInfo = items.data!
        return mangaInfo
    }
    
    // MARK: gets the genre of the manga
    func getGenre(url: String) async throws -> [Genre] {
        let url = URL(string: url)!
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        // error handling
        guard let response = response as? HTTPURLResponse else {
            throw MangaAPIError.requestFailed(message: "Response is not HTTPURLResponse")
        }
        guard 200...209 ~= response.statusCode else {
            throw MangaAPIError.requestFailed(message: "Status code \(response.statusCode) is not 2xx")
        }
        
        let items = try JSONDecoder().decode(GenreResponse.self, from: data)
        return items.data
    }
    
    
    // MARK: helper function to call Google Books API
    func callMangaAPI(url: String) async throws -> KitsuResponse {
        let url = URL(string: url)!
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        // error handling
        guard let response = response as? HTTPURLResponse else {
            throw MangaAPIError.requestFailed(message: "Response is not HTTPURLResponse")
        }
        guard 200...209 ~= response.statusCode else {
            throw MangaAPIError.requestFailed(message: "Status code \(response.statusCode) is not 2xx")
        }
        
        var items = try JSONDecoder().decode(KitsuResponse.self, from: data)
        
        // filters titles so they do not repeat
        var i = 0
        while (i < items.data?.count ?? 0) {
            if (items.data?[i].attributes.abbreviatedTitles?.count ?? 0 < 0) {
                let temp = items.data?[i].attributes.abbreviatedTitles
                items.data?[i].attributes.abbreviatedTitles = filterTitle(titles: temp!)
            }
            i = i + 1
        }
        
        // adds genres into Manga so don't have to call later
        i = 0
        while (i < items.data?.count ?? 0) {
            guard let url = items.data?[i].relationships.genres.links.related else { break }
            let genres = try await getGenre(url: url)
            var mangaGenres = [String]()
            var j = 0
            while (j < genres.count) {
                mangaGenres.append(genres[j].attributes.name)
                j = j + 1
            }
            items.data?[i].genres = mangaGenres
            j = 0
            i = i + 1
        }
        
        return items
    }
    
    // MARK: helper function to filter titles
    func filterTitle(titles: [String]) -> [String] {
        var filteredTitles = [String]()
        var i = 0, j = 0
        // add the first item in books to filteredBooks
        filteredTitles.append(titles[i])
        while (i < titles.count) {
            var repeating = false
            while (j < filteredTitles.count && repeating == false) {
                if (filteredTitles[j] == titles[i]) {
                    repeating = true
                }
                j = j + 1
            }
            if (repeating == false) {
                filteredTitles.append(titles[i])
            }
            i = i + 1
            j = 0
        }
        return filteredTitles
    }
        
}

// MARK: breaks down the manga json

struct Manga: Codable {
    let id: String
    var attributes: Attributes
    var genres: [String]?
    let relationships: Relationship
}

struct Attributes: Codable {
    let synopsis: String?
    let description: String?
    let status: String
    let posterImage: PosterImage
    let titles: Titles
    let canonicalTitle: String
    var abbreviatedTitles: [String]?
    let averageRating: String?
}

struct PosterImage: Codable {
    let original: String
}

struct Titles: Codable {
    let en: String?
    let en_jp: String?
    let en_us: String?
    let ja_jp: String?
    let ko_kr: String?
    let zh_cn: String?
}

struct Relationship: Codable {
    let genres: Genres
}

struct Genres: Codable {
    let links: Link
}

struct Link: Codable {
    let related: String
}

struct Meta: Codable {
    let count: Int
}

struct KitsuResponse: Codable {
    var data: [Manga]?
    let meta: Meta
}

// MARK: breaks down the genre json
struct Genre: Codable {
    let id: String
    let attributes: Attribute
}

struct Attribute: Codable {
    let name: String
}

struct GenreResponse: Codable {
    let data: [Genre]
}

// MARK: Errors

enum MangaAPIError: Error {
    case requestFailed(message: String)
}
