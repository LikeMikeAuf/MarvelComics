//
//  ViewController.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 17.11.2021.
//

import UIKit
import Foundation
import CryptoKit

class ViewController: UIViewController {
    
    @IBOutlet var collectiolView: UICollectionView!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectiolView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "testCell")
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "testTableCell")

    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        let time = NSDate().timeIntervalSince1970

        let timestamp = Int(time.rounded())
        let privateToken = "61e630ffe4fe5e91d19778c6512e1a5bb680b785"
        let publicToken = "dd0918cb0687e9f13bd2aa46742015c31"

        let forHashing: String = String(timestamp) + privateToken + publicToken

        //http://gateway.marvel.com/v1/public/comics?ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150

        let baseURL = "https://gateway.marvel.com/v1/public/characters"

        let hash = Insecure.MD5.hash(data: forHashing.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
        print(hash)
        
        let parametersURL = "?orderBy=name&offset=20&ts=\(timestamp)&apikey=\(publicToken)&hash=\(hash)"
        let url = baseURL + parametersURL
        print(url)
        
        getData(url)
        
    }
    
    func getData(_ url: String) {
        let url = URL(string: url)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("data:\n" + String(decoding: data, as: UTF8.self))
            }
            if let response = (response as? HTTPURLResponse) {
                print("response:\n" + String(response.statusCode))
            }
            if let error = error {
                print("error:\n" + error.localizedDescription)
            }
        }
        task.resume()
    }
    
    @IBAction func goto(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MainScreenStoryboard", bundle: nil)
        let gotoVC = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController")
        gotoVC.modalPresentationStyle = .fullScreen
        self.present(gotoVC, animated: true, completion: nil)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath) as! CollectionViewCell
        cell.nameLabel.text = "Ajak"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 9 {
            print("load next")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testTableCell", for: indexPath) as! TableViewCell
        return cell
    }
    
    
}

