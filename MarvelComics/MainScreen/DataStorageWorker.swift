//
//  DataStorageWorker.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 19.11.2021.
//

import Foundation

class DataStorageWorker {
    let amountOfCharactersInDatabase: Int = 0
    
    func fetchCharactersAmountFromStorage() -> Int {
        return amountOfCharactersInDatabase
    }
    
    func fetchCharactersFromStorage(offset: Int) -> Int {
        return 1
    }
    
//    func saveNewCharactersToDatabase(_ characters: MainScreenResponse) {
//        
//    }
}
