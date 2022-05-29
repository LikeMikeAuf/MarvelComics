//
//  ComicTableCell.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 19.11.2021.
//

import UIKit

class ComicTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet var comicThumbnail: UIImageView!
    @IBOutlet var comicTitle: UILabel!
    @IBOutlet var comicDescription: UILabel!
    
    private func configureCell() {
        comicThumbnail.layer.cornerRadius = 18
    }
    
}
