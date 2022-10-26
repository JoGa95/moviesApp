//
//  ProfileViewController.swift
//  MoviesApp
//
//  Created by Jorge Garay on 26/10/22.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var favoriteLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        populateStrings()
    }

    private func populateStrings() {
        let Text = AppStrings.ProfileScreen.self
        profileLabel.text = Text.profile.rawValue
        userLabel.text = Text.userName.rawValue
        favoriteLabel.text = Text.favoriteLabel.rawValue
        favoriteLabel.isHidden = true
        favoritesCollectionView.isHidden = true
    }
}
