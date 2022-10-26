//
//  Constants.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import Foundation

enum AppStrings: String {
    case userName = "Prueba"
    case password = "As123456"
    case loading = "Loading..."
    case ok = "Ok"

    enum LoginScreen: String {
        case loginButton = "Log in"
        case loginError = "Invalid username and/or password, you did not provide a valid login."
    }

    enum MoviesScreen: String {
        case screenTitle = "TV Shows"
        case actionSheetTitle = "What do you want to do?"
        case actionSheetMenu1 = "View Profile"
        case actionSheetMenu2 = "Log out"
        case cancel = "Cancel"
        case noDescription = "No description"
        case errorApi = "An error occurs, please try again..."
    }

    enum MoviesDetailScreen: String {
        case name = "Name: %@"
        case date = "Date: %@"
        case rating = "Rating: %@"
        case description = "Description: %@"
        case numberSeasons = "Seasons: %@"
        case numberEpisodes = "Episodes: %@"
        case title = "Executive company producers:"
    }

    enum ProfileScreen: String {
        case profile = "Profile"
        case userName = "@JoGa95"
        case favoriteLabel = "Favorite Shows"
    }
}

enum API: String {
    case url = "https://api.themoviedb.org/3/tv"
    case urlImages = "https://image.tmdb.org/t/p/w500"
    case pathPopular = "/popular?"
    case pathTopRated = "/top_rated?"
    case pathOnAir = "/on_the_air?"
    case pathAiringToday = "/airing_today?"
    case pathMovieDetail = "/%@?"
    case key = "851d616e6d7ec892d29f3ec1ed2ea0bc"
    case language = "en-US"
}

class Constants: NSObject {
    func makeUrlSession(_ url: String) -> URLComponents? {
        let url = API.url.rawValue + url
        var urlComponents = URLComponents(string: url)
        let apiQuery = URLQueryItem(name: "api_key", value: API.key.rawValue)
        let languageQuery = URLQueryItem(name: "language", value: API.language.rawValue )
        urlComponents?.queryItems?.append(apiQuery)
        urlComponents?.queryItems?.append(languageQuery)
        return urlComponents
    }
}
