//
//  CharactersModel.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 17.11.2021.
//
//   let characters = try? newJSONDecoder().decode(Characters.self, from: jsonData)

import Foundation

// MARK: - Characters
struct Characters: Decodable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Decodable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Result]?
}

// MARK: - Result
struct Result: Decodable {
    let id: Int?
    let name: String?
    let resultDescription: String?
    let modified: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics: Comics?
    let series: Comics?
    let stories: Stories?
    let events: Comics?
    let urls: [URLElement]?
}

// MARK: - Comics
struct Comics: Decodable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicsItem]?
    let returned: Int?
}

// MARK: - ComicsItem
struct ComicsItem: Decodable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Stories
struct Stories: Decodable {
    let available: Int?
    let collectionURI: String?
    let items: [StoriesItem]?
    let returned: Int?
}

// MARK: - StoriesItem
struct StoriesItem: Decodable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

// MARK: - Thumbnail
struct Thumbnail: Decodable {
    let path: String?
    let thumbnailExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement: Decodable {
    let type: String?
    let url: String?
}
