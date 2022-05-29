//
//  TableViewCell.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 18.11.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        configureImageView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBOutlet var comicThumbnail: UIImageView!
    @IBOutlet var comicDescription: UILabel!
    
    
    private func configureImageView() {
        comicThumbnail.layer.cornerRadius = 18
    }
    
}
