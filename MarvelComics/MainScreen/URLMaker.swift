//
//  URLMaker.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 20.11.2021.
//

import Foundation
import CryptoKit

// Singleton
class URLMaker {
    
    static let shared = URLMaker()
    
    private let privateToken = "61e630ffe4fe5e91d19778c6512e1a5bb680b785"
    private let publicToken = "dd0918cb0687e9f13bd2aa46742015c3"
    
    private func makeHash() -> (timestamp: Int, hash: String) {
        let time = NSDate().timeIntervalSince1970

        let timestamp = Int(time.rounded())
        let privateToken = "61e630ffe4fe5e91d19778c6512e1a5bb680b785"
        let publicToken = "dd0918cb0687e9f13bd2aa46742015c3"

        let forHashing: String = String(timestamp) + privateToken + publicToken
        let hash = Insecure.MD5.hash(data: forHashing.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
        
        return (timestamp: timestamp, hash: hash)
    }
    
    func createCharactersURL(offset: Int) -> URL {
        let (timestamp, hash) = makeHash()

        let baseURL = "https://gateway.marvel.com/v1/public/characters"
        
        let parametersURL = "?orderBy=name&offset=\(offset)&ts=\(timestamp)&apikey=\(publicToken)&hash=\(hash)"
        let url = baseURL + parametersURL
        
        print(url)
        
        return URL(string: url)!
        
        //http://gateway.marvel.com/v1/public/comics?ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150
    }
    
    func createComicsURL(characterID: Int, offset: Int) -> URL {
        let (timestamp, hash) = makeHash()

        let baseURL = "https://gateway.marvel.com/v1/public/characters/\(characterID)/comics"
        
        let parametersURL = "?format=comic&noVariants=true&orderBy=title&offset=\(offset)&ts=\(timestamp)&apikey=\(publicToken)&hash=\(hash)"
        let url = baseURL + parametersURL
        
        print(url)
        
        return URL(string: url)!
        
        //https://gateway.marvel.com/v1/public/characters/1010370/comics?format=comic&noVariants=true&orderBy=title
    }
}
