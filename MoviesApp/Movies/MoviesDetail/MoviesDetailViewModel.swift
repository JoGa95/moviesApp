//
//  MoviesDetailViewModel.swift
//  MoviesApp
//
//  Created by Jorge Garay on 25/10/22.
//
import UIKit
final class MoviesDetailViewModel: BaseViewModel<MoviesDetailState>, MoviesDetailViewModelType {
    private let moviesService: MoviesService
    private let movieId: String
    private let vc = UIViewController()

    private var favoritesMovieArray: [MoviesState.MoviesData] = []

    init(moviesService: MoviesService, movieId: String) {
        self.moviesService = moviesService
        self.movieId = movieId
    }

    override func start() {
        if case .idle = state {
            getMovieDetail()
        }
    }

    var isFavoriteMovie: Bool {
        let movie = favoritesMovieArray.first(where: {$0.id == Int(movieId)}) ?? nil
        return movie != nil
    }

    func getMovieDetail() {
        vc.showLoader()
        moviesService.getMovieDetail(movieId) { result in
            if let data = result.data, result.success {
                self.state = .started(.init(id: data.id, image: data.posterPath, title: data.name, date: data.airDate, rating: data.voteAverage, description: data.description, numberEpisodes: data.numberEpisodes!, numberSeasons: data.numberSeasons!, networks: data.networks!))
            } else {
                self.vc.showAlert(message: AppStrings.MoviesScreen.errorApi.rawValue)
            }
        }
    }

}
