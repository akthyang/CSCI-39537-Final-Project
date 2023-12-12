//
//  LightNovelAPI.swift
//  Books2Love
//
//  Created by Alicia Yang on 12/11/23.
//  MARK: Calls WebNovel API from RapidAPI

import Foundation

struct LightNovelAPI {
    
    static var shared = LightNovelAPI()
    
    private var allNovels = [Novels]()
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    let headers = [
        "X-RapidAPI-Key": "94c41c68femsheda91ee6cfa6e94p1ba3bajsnb95b1b9d48b8",
        "X-RapidAPI-Host": "webnovel.p.rapidapi.com"
    ]

    // MARK: fills allNovels array and returns an array of 10 novels
    mutating func getNovels() async throws -> [Novels] {
        let data = try await callRapidAPI(url: "https://webnovel.p.rapidapi.com/novels/1")
        let items = try JSONDecoder().decode(NovelResponse.self, from: data)
        allNovels = items.novels
        var novels = [Novels]()
        var i = 0
        while (i < 10) {
            allNovels[i] = try await getNovelInfo(id: allNovels[i].id)
            novels.append(allNovels[i])
            i = i + 1
        }
        return novels
    }
    
    // MARK: gets the info for each novel
    mutating func getNovelInfo(id: String) async throws -> Novels {
        let index = allNovels.indices.filter({allNovels[$0].id == id})
        if (allNovels[index[0]].novelInfo == nil) {
            let data = try await callRapidAPI(url: "https://webnovel.p.rapidapi.com/novel/\(id)")
            let item = try JSONDecoder().decode(NovelInfo.self, from: data)
            allNovels[index[0]].novelInfo = item
        }
        return allNovels[index[0]]
    }
    
    // MARK: gets the chapter for the novel
    mutating func getChapter(chapter: Chapter, novel: Novels) async throws -> Chapter {
        let novelIndex = allNovels.indices.filter({allNovels[$0].id == novel.id})
        let chapterIndex = allNovels[novelIndex[0]].novelInfo?.novel.chapters?.indices.filter({allNovels[novelIndex[0]].novelInfo?.novel.chapters?[$0].url == chapter.url})
        if (allNovels[novelIndex[0]].novelInfo?.novel.chapters?[(chapterIndex?[0])!].content == nil) {
            let data = try await callRapidAPI(url: "https://webnovel.p.rapidapi.com/novel/\(novel.id)/\(chapter.url!)")
            let item = try JSONDecoder().decode(ChapterResponse.self, from: data)
            allNovels[novelIndex[0]].novelInfo?.novel.chapters?[chapterIndex![0]].content = item.chapter.content
        }
        return (allNovels[novelIndex[0]].novelInfo?.novel.chapters![chapterIndex![0]])!
    }
    
    // MARK: filters through allNovels for keywords
    mutating func search(keyword: String) async throws -> [Novels] {
        var filterByTitle = allNovels.filter({$0.title.contains(keyword.lowercased())})
        print(filterByTitle)
        let count = filterByTitle.count
        let filterBySummary = allNovels.filter({$0.novelInfo?.novel.summary.contains(keyword.lowercased()) ?? $0.title.contains(keyword)})
        var i = 0
        while (i < filterBySummary.count) {
            filterByTitle.append(filterBySummary[i])
            i = i + 1
        }
        let filteredNovel = try await filterSearch(novel: filterByTitle, index: count)
        return filteredNovel
    }
    
    // MARK: helper function to call RapidAPI
    func callRapidAPI(url: String) async throws -> Data {
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.allHTTPHeaderFields = headers
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        // error handling
        guard let response = response as? HTTPURLResponse else {
            throw BookAPIError.requestFailed(message: "Response is not HTTPURLResponse")
        }
        guard 200...209 ~= response.statusCode else {
            throw BookAPIError.requestFailed(message: "Status code \(response.statusCode) is not 2xx")
        }
        
        return data
    }
    
    // MARK: helper function to call filter search so results do not repeat
    mutating func filterSearch(novel: [Novels], index: Int) async throws -> [Novels] {
        var filteredNovels = [Novels]()
        var temp = novel
        var i = 0, j = 0
        while (i < temp.count) {
            var repeating = false
            while (j < filteredNovels.count && repeating == false && i > index - 1) {
                if (filteredNovels[j].title == temp[i].title) {
                    repeating = true
                }
                j = j + 1
            }
            temp[i] = try await getNovelInfo(id: novel[i].id)
            if (repeating == false) {
                filteredNovels.append(temp[i])
            }
            i = i + 1
            j = 0
        }
        return filteredNovels
    }

}

struct Novels: Codable {
    var id: String
    var title: String
    var novelInfo: NovelInfo?
}

struct NovelInfo: Codable {
    var novel: NovelInfos
}

struct NovelInfos: Codable {
    var title: String
    var cover: String
    var author: String
    var summary: String
    var genre: String
    var status: String
    var chapters: [Chapter]?
}

struct Chapter: Codable {
    let url: String?
    let title: String
    var content: String?
    let next: String?
    let prev: String?
    let index: String?
}

struct ChapterResponse: Codable {
    let chapter: Chapter
}

struct NovelResponse: Codable {
    var novels: [Novels]
}

// MARK: Errors

enum LightNovelAPIError: Error {
    case requestFailed(message: String)
}
