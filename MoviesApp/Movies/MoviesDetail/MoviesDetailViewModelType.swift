//
//  MoviesDetailViewModelType.swift
//  MoviesApp
//
//  Created by Jorge Garay on 25/10/22.
//

protocol MoviesDetailViewModelType: ViewModelType {
    var state: MoviesDetailState { get }
}

enum MoviesDetailState: ViewModelStateType {
    struct MoviesDetailData {
        let id: Int
        let image: String
        let title: String
        let date: String
        let rating: Float
        let description: String
        let numberEpisodes: Int
        let numberSeasons: Int
        let networks: [NetworkData]
    }

    case idle, started(MoviesDetailData)
}
