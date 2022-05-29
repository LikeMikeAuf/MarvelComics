//
//  CollectionViewCell.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 17.11.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let cornerRadius: CGFloat = 25
        
        imageView.layer.cornerRadius = cornerRadius - 4
//        imageView.layer.borderWidth = 2
//        imageView.layer.borderColor = UIColor.white.cgColor
        
        let borderView = UIView(frame: imageView.frame)
        
        
        let layer = CALayer()
        layer.frame = CGRect(x: (imageView.bounds.origin.x - 5), y: (imageView.bounds.origin.y - 5), width: (imageView.frame.width + 10), height: (imageView.frame.height + 10))
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.borderWidth = 2.7
        layer.cornerRadius = cornerRadius
        
        borderView.layer.addSublayer(layer)
        imageView.superview?.addSubview(borderView)
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
}
