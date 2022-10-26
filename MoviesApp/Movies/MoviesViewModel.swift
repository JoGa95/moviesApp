//
//  MoviesViewModel.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import Foundation
import UIKit

final class MoviesViewModel: BaseViewModel<MoviesState>, MoviesViewModelType {
    private let moviesService: MoviesService

    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }

    override func start() {
        if case .idle = state {
            getMovies(API.pathPopular.rawValue)
        }
    }

    func getMovies(_ path: String, _ vc: UIViewController = UIViewController()) {
        vc.showLoader()
        moviesService.getMovies(path) { result in
            vc.hideLoder()
            if result.success {
                self.state = .started(self.createMoviesData(result))
            } else {
                vc.showAlert(message: AppStrings.MoviesScreen.errorApi.rawValue)
            }

        }
    }

    private func createMoviesData(_ result: Result) -> [MoviesState.MoviesData] {
        var movies: [MoviesState.MoviesData] = []
        for movie in result.data!.results {
            movies.append(.init(id: movie.id, image: movie.posterPath, title: movie.name, date: movie.airDate, rating: movie.voteAverage, description: movie.description))
        }
        return movies
    }

    func logOutUser(_ vc: UIViewController) {
        let viewModel = LoginViewModel(loginService: LoginService())
        UserDefaults.standard.removeObject(forKey: "userIsLogged")
        let viewController = LoginViewController(viewModel: viewModel)
        vc.pushViewController(viewController: viewController)
    }

    func showProfileScreen(_ vc: UIViewController) {
        let viewController = ProfileViewController()
        vc.pushViewController(viewController: viewController)
    }

    func openMovieDetailScreen(_ vc: UIViewController, _ movieId: String) {
        let viewModel = MoviesDetailViewModel(moviesService: MoviesService(), movieId: movieId)
        let viewController = MoviesDetailViewController(viewModel: viewModel)
        vc.pushViewController(viewController: viewController)
    }
}

