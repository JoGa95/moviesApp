//
//  MoviesViewModelType.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import Foundation
import UIKit

protocol MoviesViewModelType: ViewModelType {
    var state: MoviesState { get }

    func getMovies(_ path: String, _ vc: UIViewController)
    func logOutUser(_ vc: UIViewController)
    func showProfileScreen(_ vc: UIViewController)
    func openMovieDetailScreen(_ vc: UIViewController, _ movieId: String)
}

enum MoviesState: ViewModelStateType {
    struct MoviesData: Codable {
        let id: Int
        let image: String
        let title: String
        let date: String
        let rating: Float
        let description: String
    }

    case idle, started([MoviesData])
}

