//
//  Result.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import Foundation

// MARK: - Result
class Result: NSObject {
    var success: Bool
    var data: MoviesResult?

    init(_ success: Bool, _ data: MoviesResult?) {
        self.success = success
        self.data = data
    }
}

// MARK: - DetailResult
class DetailResult: NSObject {
    var success: Bool
    var data: MovieResult?

    init(_ success: Bool, _ data: MovieResult?) {
        self.success = success
        self.data = data
    }
}

// MARK: - MoviesResult
struct MoviesResult: Codable {
    let results: [MovieResult]
}

// MARK: - MovieResult
struct MovieResult: Codable {
    let id: Int
    let name: String
    let description: String
    let posterPath: String
    let airDate: String
    let voteAverage: Float
    let numberEpisodes: Int?
    let numberSeasons: Int?
    let networks: [NetworkData]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "overview"
        case posterPath = "poster_path"
        case airDate = "first_air_date"
        case voteAverage = "vote_average"
        case networks = "networks"
        case numberEpisodes = "number_of_episodes"
        case numberSeasons = "number_of_seasons"
    }
}

struct NetworkData: Codable {
    let id: Int
    let name: String
    let logoPath: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case logoPath = "logo_path"
    }
}
