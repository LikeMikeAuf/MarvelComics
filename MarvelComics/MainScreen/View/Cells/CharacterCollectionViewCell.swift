//
//  CharacterCollectionViewCell.swift
//  MarvelComics
//
//  Created by Михаил Лоюк on 19.11.2021.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        configureView()
    }

    @IBOutlet var characterAvatar: UIImageView!
    @IBOutlet var characterName: UILabel!
    
    var activityIndicator: UIActivityIndicatorView!
    
    private func configureView() {
        // Rounded image corners configuration
        let cornerRadius: CGFloat = 25
        characterAvatar.layer.cornerRadius = cornerRadius - 4
        
        // Border frame configuration
        let borderView = UIView(frame: characterAvatar.frame)
        let layer = CALayer()
        layer.frame = CGRect(x: (characterAvatar.bounds.origin.x - 5),
                             y: (characterAvatar.bounds.origin.y - 5),
                             width: (characterAvatar.frame.width + 10),
                             height: (characterAvatar.frame.height + 10))
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.borderWidth = 2.7
        layer.cornerRadius = cornerRadius
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = characterAvatar.center
        activityIndicator.startAnimating()
        
        borderView.layer.addSublayer(layer)
        characterAvatar.superview?.addSubview(borderView)
        characterAvatar.superview?.addSubview(activityIndicator)
    }
}
