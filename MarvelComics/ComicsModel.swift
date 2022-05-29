//
//  ComicsModel.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 26.11.2021.
//

import Foundation

// MARK: - Comics
struct Comic: Decodable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: ComicData?
}

// MARK: - ComicData
struct ComicData: Decodable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [ComicResult]?
}

// MARK: - ComicResult
struct ComicResult: Decodable {
    let id: Int?
    let digitalID: Int?
    let title: String?
    let issueNumber: Int?
    let variantDescription: String?
    let description: String?
    let modified: String?
    let isbn: String?
    let upc: String?
    let diamondCode: String?
    let ean: String?
    let issn: String?
    let format: String?
    let pageCount: Int?
    let textObjects: [ComicTextObject]?
    let resourceURI: String?
    let urls: [ComicURL]?
    let series: ComicSeries?
    let variants: [ComicVariant]?
    let collections: [ComicSeries]?
    let collectedIssues: [String?]? //[Comic Summary] not implemented
    let dates: [ComicDate]?
    let prices: [ComicPrice]?
    let thumbnail: ComicThumbnail?
    let images: [ComicThumbnail]?
    let creators: ComicCreators?
    let characters: ComicCharacters?
    let stories: ComicStories?
    let events: ComicCharacters?
}

// MARK: - ComicCharacters
struct ComicCharacters: Decodable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicSeries]?
    let returned: Int?
}

// MARK: - ComicSeries
struct ComicSeries: Decodable {
    let resourceURI: String?
    let name: String?
}

// MARK: - ComicVariant
struct ComicVariant: Decodable {
    let resourceURI: String?
    let name: String?
}


// MARK: - ComicCreators
struct ComicCreators: Decodable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicCreatorsItem]?
    let returned: Int?
}

// MARK: - ComicCreatorsItem
struct ComicCreatorsItem: Decodable {
    let resourceURI: String?
    let name: String?
    let role: String?
}

// MARK: - ComicDate
struct ComicDate: Decodable {
    let type: String?
    let date: String?
}

// MARK: - ComicThumbnail
struct ComicThumbnail: Decodable {
    let path: String?
    let thumbnailExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case thumbnailExtension = "extension"
    }
}

// MARK: - ComicPrice
struct ComicPrice: Decodable {
    let type: String?
    let price: Double?
}

// MARK: - ComicStories
struct ComicStories: Decodable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicStoriesItem]?
    let returned: Int?
}

// MARK: - ComicStoriesItem
struct ComicStoriesItem: Decodable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

// MARK: - ComicTextObject
struct ComicTextObject: Decodable {
    let type: String?
    let language: String?
    let text: String?
}

// MARK: - ComicURL
struct ComicURL: Decodable {
    let type: String?
    let url: String?
}
