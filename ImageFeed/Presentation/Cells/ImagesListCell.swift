//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by vs on 11.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    func configure(image: UIImage?, likeImage: UIImage?, dateString: String) {
        cellImage.image = image
        likeButton.setImage(likeImage, for: .normal)
        dateLabel.text = dateString
    }
    
}
