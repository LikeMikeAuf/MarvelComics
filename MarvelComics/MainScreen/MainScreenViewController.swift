//
//  MainScreenViewController.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 19.11.2021.
//

import UIKit

class MainScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register custom cells for Table and Collection Views
        mainFeedTableView.register(UINib(nibName: "ComicTableCell", bundle: nil), forCellReuseIdentifier: "mainFeedCell")
        avatarsCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "avatarCell")

//        avatarsCollectionView.con
        
        // Setup dependencies
        dependenciesConfiguration()
//        avatarsCollectionView.delegate = interactor.presenter as? UICollectionViewDelegate
//        avatarsCollectionView.dataSource = interactor.presenter as? UICollectionViewDataSource
    }
    
//    MARK: - Dependencies section
    
    var interactor: MainScreenInteractor!
    
    private func dependenciesConfiguration() {
        let viewController = self
        let interactor = MainScreenInteractor()
        let presenter = MainScreenPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
//    MARK: - State
    
    private var loadedCharactersCounter: Int = 0
    var numberOfCharacters: Int = 0
    
    var numberOfComics: Int = 0
    
    var selectedCharacterID: Int = 0
    
    var isInitialLoad: Bool = true
    
//    MARK: - Character avatars CollectionView
    
    @IBOutlet var avatarsCollectionView: UICollectionView! //{
//        didSet {
//            avatarsCollectionView.delegate = interactor.presenter as? UICollectionViewDelegate
//            avatarsCollectionView.dataSource = interactor.presenter as? UICollectionViewDataSource
//        }
//    }
    
//    MARK: - Main feed TableView
    
    @IBOutlet var mainFeedTableView: UITableView!
    

    // temporary
    @IBOutlet var loadButton: UIButton!
    
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        Task {
            await interactor.loadCharacters(offset: loadedCharactersCounter)
        }
//        self.loadedCharactersCounter += 20 // temporary += count
        loadButton.isUserInteractionEnabled = false
    }
    
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfComics
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainFeedCell") as! ComicTableCell
        cell.comicThumbnail.image = UIImage(imageLiteralResourceName: "marvel_m")
        cell.comicTitle.text = "Loading..."
        cell.comicDescription.text = ""
        Task {
            await interactor.getContentForComicCell(indexPath)
        }
        return cell
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return numberOfCharacters
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! CharacterCollectionViewCell
        if indexPath == IndexPath(item: 0, section: 1) {
            cell.characterAvatar.image = UIImage(imageLiteralResourceName: "marvel_m")
            cell.characterName.text = "Loading..."
            cell.activityIndicator.startAnimating()
        } else {
            interactor.getContentForCharactersCell(indexPath)
            cell.activityIndicator.stopAnimating()
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath == IndexPath(item: 0, section: 1) {
            let offset = collectionView.numberOfItems(inSection: 0)
            Task { [unowned self] in
                await interactor.loadCharacters(offset: offset)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.numberOfComics = 1
        self.mainFeedTableView.reloadData()
        Task {
            await interactor.loadComicsForCharacter(indexPath: indexPath)
        }
    }
}
