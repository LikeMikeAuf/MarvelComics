//
//  MainScreenInteractor.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 19.11.2021.
//

import Foundation
import UIKit

enum LoadingDataType {
    case characters
    case comics
}

protocol MainScreenInteractorRequestProtocol {
    
}

struct CharactersModel {
    var indexPath: IndexPath
    var name: String
    var thumbnail: UIImage
    var characterID: Int
}

struct ComicModel {
    var title: String
    var description: String?
    var thumbnail: UIImage?
    var thumbnailModel: ComicThumbnail?
}

class MainScreenInteractor: MainScreenInteractorRequestProtocol {
    
    // TEMPORARY
//    MARK: - State
    
    var charactersDictionary: [IndexPath: CharactersModel] = [:]
    
    var charactersModel = [(id: Int, name: String, thumbnail: Thumbnail)]()
    
    var isLoading: Bool = false
    
    var comicDictionary: [Int: [ComicModel]] = [:] // [character ID: array of comics]
    var selectedCharacterID: Int = 0
    
    // Dependencies
    var presenter: MainScreenPresenter?
    var networkWorker = NetworkLayerWorker()
    var localStorageWorker = DataStorageWorker()
    
//    MARK: - UI Interaction
    
    private let lockQueue = DispatchQueue(label: "characterSaving.lock.queue")
    
    func getContentForCharactersCell(_ indexPath: IndexPath) {
        if let model = charactersDictionary[indexPath] {
            presenter?.updateCell(name: model.name, thumbnail: model.thumbnail, indexPath: indexPath)
        } else

        if charactersModel.indices.contains(indexPath.item) {
            Task {
                let model = charactersModel[indexPath.item]
                let thumbnail: UIImage = await loadCharacterThumbnail(model.thumbnail)
//                DispatchQueue.global().async {
                    lockQueue.async {
                        self.charactersDictionary[indexPath] = CharactersModel(indexPath: indexPath,
                                                                               name: model.name,
                                                                               thumbnail: thumbnail,
                                                                               characterID: model.id)
                    }
//                }
                
                presenter?.updateCell(name: model.name, thumbnail: thumbnail, indexPath: indexPath)
            }
        }
    }
    
//    private func addItemsForCharactersCollectionView() {
//        let numberOfCellsToAdd = charactersModel.count
//
//        presenter?.updateCharactersAmountInCollectionView(amountToAdd: numberOfCellsToAdd)
//    }
    
    func loadCharacters(offset: Int) async {
        
        guard !isLoading else { return }
        isLoading = true
        
        // if less than 24 hours passed since last upload!
        
        if checkForCharactersInLocalStorage(offset: offset) {
            // try to get data from local storage
            let characters = localStorageWorker.fetchCharactersFromStorage(offset: offset)

            // presentDataFromDatabase()
        }
        
        else {
            // load data from network if unavailable locally
            let url = URLMaker.shared.createCharactersURL(offset: offset)
            let networkResponse = await networkWorker.loadDataFromNetwork(url: url)
            // an error alert presents if statusCode != 200
            guard processNetworkResponse(statusCode: networkResponse.statusCode, data: networkResponse.data) else { return }
            
            let parsedData: Characters = parseData(data: networkResponse.data)
            
            createCharactersModelForResponse(parsedData) // possible concurrency issues
            
            presenter?.updateCharactersAmountInCollectionView(newAmount: charactersModel.count)
            
            DispatchQueue.main.async {
                self.presenter?.viewController?.avatarsCollectionView.reloadData()
                self.isLoading = false
            }
            
//            Task {
//                for (index, item) in charactersModel.enumerated() {
//                    let thumbnail: UIImage = await loadCharacterThumbnail(item.thumbnail)
//                    let row = offset + index
//                    presenter?.presentCharacters(name: item.name, thumbnail: thumbnail, index: row)
//                }
//            }
            
        }
    }
    
    private func checkForCharactersInLocalStorage(offset: Int) -> Bool {
        
        let storedCharactersAmount = localStorageWorker.fetchCharactersAmountFromStorage()
        if storedCharactersAmount >= (offset + 20) {
            return true
        } else {
            return false
        }
    }
    
    private func processNetworkResponse(statusCode: Int, data: Data) -> Bool {
        if statusCode == 200 {
            return true
            // saveDataToDatabase()
            // parse data
            /*
             prepare response for presenter:
             - get characters names
             - get character thumbnails
             */
        } else if statusCode == 401 {
            var error: ErrorCode401?
            do {
                error = try JSONDecoder().decode(ErrorCode401.self, from: data)
            } catch {
                print("An error occured while decoding Error JSON")
            }
            // HANDLE NIL ERROR CASE
            presenter?.presentErrorAlert(statusCode: statusCode, error: error!)
            return false
            
        } else if statusCode == 409 {
            // REFACTOR
            var error409: ErrorCode409?
            do {
                error409 = try JSONDecoder().decode(ErrorCode409.self, from: data)
            } catch {
                print("An error occured while decoding Error JSON")
            }
            let error = ErrorCode401(code: String((error409?.code)!), message: error409?.status)
            // HANDLE NIL ERROR CASE
            presenter?.presentErrorAlert(statusCode: statusCode, error: error)
            return false
        } else { return false }
    }
    
    private func parseData<T: Decodable>(data: Data) -> T {
        // HANLDE NIL CASE
        var characters: T?
        do {
            characters = try JSONDecoder().decode(T.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        return characters!
    }
    
    // NEEDS EDIT
    private func createCharactersModelForResponse<T>(_ data: T) {
        if let data = data as? Characters {
            // characters model:
//            var characters = [(name: String, thumbnail: Thumbnail)]()
            // check if [results].count is equal to count of records returned NOT NESSESARY, TO REMOVE:
            if data.data?.results?.count == data.data?.count {
                for item in data.data!.results! {
                    let character = (id: item.id!, name: item.name!, thumbnail: item.thumbnail!)
                    charactersModel.append(character)
                }
            } else {
                print("[results].count is NOT equal to count of records returned")
            }
            // for further implementation
        }
    }
    
    private func loadCharacterThumbnail(_ thumbnail: Thumbnail) async -> UIImage {
        let url = URL(string: "https" + thumbnail.path!.dropFirst(4) + "/standard_large." + thumbnail.thumbnailExtension!)!
        let response = await networkWorker.loadDataFromNetwork(url: url)
        print("image loading status code: \(response.statusCode)")
        
        let image = UIImage(data: response.data) ?? UIImage()
        return image
    }
    
//    MARK: - Comics prossesing
    
    func loadComicsForCharacter(indexPath: IndexPath) async {
        let characterID: Int = charactersDictionary[indexPath]!.characterID
        selectedCharacterID = characterID
        
        if let _ = comicDictionary[characterID] {
            presenter?.updateComicsNumberInTableView(newNumber: comicDictionary[characterID]!.count)
        } else {
            let url = URLMaker.shared.createComicsURL(characterID: characterID, offset: 0)
            let networkResponse = await networkWorker.loadDataFromNetwork(url: url)
            // an error alert presents if statusCode != 200
            guard processNetworkResponse(statusCode: networkResponse.statusCode, data: networkResponse.data) else { return }
            
            let parsedData: Comic = parseData(data: networkResponse.data)
            Task {
                await createComicModel(for: characterID, using: parsedData)
                presenter?.updateComicsNumberInTableView(newNumber: comicDictionary[characterID]!.count)
            }
        }
        
        
        // TODO: update text content first
//        for item in comicDictionary[characterID] {
//
//        }
    }
    
    private func createComicModel(for characterID: Int, using parsedData: Comic) async {
        var model: [ComicModel] = []
        // HANDLE NIL CASE
        for item in parsedData.data!.results! {
            let comic = ComicModel(title: item.title!, description: item.description, thumbnail: nil, thumbnailModel: item.thumbnail)
            model.append(comic)
        }
        comicDictionary[characterID] = model
        return
    }
    
    func getContentForComicCell(_ indexPath: IndexPath) async {
        if let model = comicDictionary[selectedCharacterID] {
            guard indexPath.row <= model.count - 1 else { return }
            var item = model[indexPath.row]
            if item.thumbnail == nil {
                item.thumbnail = await loadComicThumbnail(item.thumbnailModel!)
                var newModel = model
                newModel[indexPath.row] = item
                    comicDictionary[selectedCharacterID] = newModel
                }
                presenter?.updateComicCell(title: item.title,
                                           description: item.description ?? "",
                                           thumbnail: item.thumbnail!,
                                           indexPath: indexPath)
            
        } else {
            print("'if let' error getContentForComicCell()")
        }
    }
    
//    TODO: merge with loadCharacterThumbnail()
    private func loadComicThumbnail(_ thumbnail: ComicThumbnail) async -> UIImage {
        let url = URL(string: "https" + thumbnail.path!.dropFirst(4) + "/portrait_xlarge." + thumbnail.thumbnailExtension!)!
        let response = await networkWorker.loadDataFromNetwork(url: url)
        print("image loading status code: \(response.statusCode)")
        
        let image = UIImage(data: response.data) ?? UIImage()
        return image
    }
}

// temporary
struct MainScreenCharacterResponse {
    let name: String
    let thumbnail: UIImage
}
