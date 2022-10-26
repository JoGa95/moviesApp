//
//  MoviesDetailCollectionViewCell.swift
//  MoviesApp
//
//  Created by Jorge Garay on 26/10/22.
//

import UIKit

class MoviesDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var nameDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(model: NetworkData) {
        let url = URL(string: API.urlImages.rawValue + model.logoPath)!
        detailImageView.downloaded(from: url)
        nameDetailLabel.text = model.name
    }

}
