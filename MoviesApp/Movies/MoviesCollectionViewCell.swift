//
//  MoviesCollectionViewCell.swift
//  MoviesApp
//
//  Created by Jorge Garay on 25/10/22.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(model: MoviesState.MoviesData) {
        let url = URL(string: API.urlImages.rawValue + model.image)!
        movieImageView.downloaded(from: url)
        nameLabel.text = model.title
        dateLabel.text = model.date
        descriptionLabel.text = model.description.isEmpty ?  AppStrings.MoviesScreen.noDescription.rawValue : model.description
        setRateLabel(String(model.rating))
    }

    func setRateLabel(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text + " ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        let loveAttachment = NSTextAttachment()
        loveAttachment.image = UIImage(named: "ic_star")
        loveAttachment.bounds = CGRect(x: 0, y: -5, width: 15, height: 20)
        attributedString.append(NSAttributedString(attachment: loveAttachment))
        rateLabel.attributedText = attributedString
    }

}
