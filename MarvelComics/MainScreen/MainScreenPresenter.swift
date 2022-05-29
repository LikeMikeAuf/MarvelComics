//
//  MainScreenPresenter.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 19.11.2021.
//

import Foundation
import UIKit

protocol MainScreenPresenterProtocol {
    
}

class MainScreenPresenter: MainScreenPresenterProtocol {
    
    weak var viewController: MainScreenViewController?
    
    func presentCharacters(name: String, thumbnail: UIImage, index: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = self.viewController?.avatarsCollectionView.cellForItem(at: indexPath) as! CharacterCollectionViewCell
            cell.characterAvatar.image = thumbnail
            cell.characterName.text = name
            
//            viewController?.avatarsCollectionView.indexPathsForVisibleItems
        }
    }
    
    func updateCell(name: String, thumbnail: UIImage, indexPath: IndexPath) {
        DispatchQueue.main.async {
            let collectionView = self.viewController?.avatarsCollectionView
            if let cell = collectionView?.cellForItem(at: indexPath) as? CharacterCollectionViewCell {
                cell.characterName.text = name
                cell.characterAvatar.image = thumbnail
                cell.activityIndicator.stopAnimating()
//                collectionView?.reloadItems(at: [indexPath])
            }
        }
    }
    
    func updateCharactersAmountInCollectionView(newAmount: Int) {
        
        // TODO: Check possibility of updating collectionView.numberOfItemsInSection
        
        DispatchQueue.main.async { [unowned self] in
            guard let collectionView = viewController?.avatarsCollectionView else { return }
            
            let startingIndex = (viewController?.avatarsCollectionView.numberOfItems(inSection: 0))!
            
            var indicesToAdd = [IndexPath]()
            for position in startingIndex..<newAmount {
                let index = IndexPath(item: position, section: 0)
                indicesToAdd.append(index)
            }

            viewController?.numberOfCharacters += indicesToAdd.count
            
            collectionView.insertItems(at: indicesToAdd)
//            if startingIndex == 1 {
//                collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
//            }
        }
    }
    
    func presentErrorAlert(statusCode: Int, error: ErrorCode401) {
        DispatchQueue.main.async {
            // edit 404
            let alert = UIAlertController(title: "Error \(statusCode) \(error.code ?? String(404))",
                                          message: error.message,
                                          preferredStyle: .alert)
            // TODO: IMPLEMENT RETRY ACTION
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            
            alert.addAction(action)
            self.viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
//    MARK: - Comics interaction
    
    func updateComicsNumberInTableView(newNumber: Int) {
        DispatchQueue.main.async { [unowned self] in
            viewController?.numberOfComics = newNumber
            viewController?.mainFeedTableView.reloadData()
        }
    }
    
    func updateComicCell(title: String, description: String, thumbnail: UIImage, indexPath: IndexPath) {
        DispatchQueue.main.async {
            let tableView = self.viewController?.mainFeedTableView
            if let cell = tableView?.cellForRow(at: indexPath) as? ComicTableCell {
                cell.comicTitle.text = title
                if description == "" {
                    cell.comicDescription.text = "Description is not available"
                } else {
                    cell.comicDescription.text = description
                }
                cell.comicThumbnail.image = thumbnail
//                cell.activityIndicator.stopAnimating()
//                collectionView?.reloadItems(at: [indexPath])
            }
        }
    }
}

//extension MainScreenPresenter: UICollectionViewDelegate, UICollectionViewDataSource, UIViewController {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 20
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! CharacterCollectionViewCell
////        let content = interactor.getContentForCharactersCell(indexPath)
//        return cell
//    }
    
//}
