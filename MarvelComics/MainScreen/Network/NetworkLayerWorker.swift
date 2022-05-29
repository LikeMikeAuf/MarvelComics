//
//  NetworkLayerWorker.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 19.11.2021.
//

import Foundation

class NetworkLayerWorker {
    // the function returns a tuple of (statusCode, data)
    func loadDataFromNetwork(url: URL) async -> (statusCode: Int, data: Data) {
        var (data, response): (Data?, URLResponse?)
        
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            print("An error occured while loading data from network")
        }
        
//        if let httpResponse = response as? HTTPURLResponse {
//            handleHTTPcode(statusCode: httpResponse.statusCode, description: httpResponse.description)
//        }
//        if let data = data {
//            print(String(decoding: data, as: UTF8.self))
//        }
        
        let outputData = data ?? Data()
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        
        return (statusCode, outputData)
    }
    
    private func handleHTTPcode(statusCode: Int, description: String) {
//        print("Code: " + String(statusCode) + ": " + description)
        print(HTTPURLResponse.localizedString(forStatusCode: statusCode))
        
    }
}
