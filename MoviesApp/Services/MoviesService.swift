//
//  MoviesService.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import Foundation

let constants = Constants()

final class MoviesService: Decodable {
    func getMovies(_ path: String, _ completion: @escaping (_ result: Result) -> Void) {
        let urlComponents = constants.makeUrlSession(path)
        let task = URLSession(configuration: .default).dataTask(with: (urlComponents?.url!)!) { data, response, error in
            // Check for errors
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            // Check that data has been returned
            guard let data = data else {
                print("No data")
                return
            }

            do {
                let response = try JSONDecoder().decode(MoviesResult.self, from: data)
                completion(Result(true, response))
            } catch let err {
                completion(Result(false, nil))
                print("Err", err)
            }
        }
        // execute the HTTP request
        task.resume()
    }

    func getMovieDetail(_ movieID: String, _ completion: @escaping (_ result: DetailResult) -> Void) {
        let path = String(format: API.pathMovieDetail.rawValue, movieID)
        let urlComponents = constants.makeUrlSession(path)
        let task = URLSession(configuration: .default).dataTask(with: (urlComponents?.url!)!) { data, response, error in
            // Check for errors
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            // Check that data has been returned
            guard let data = data else {
                print("No data")
                return
            }

            do {
                let response = try JSONDecoder().decode(MovieResult.self, from: data)
                completion(DetailResult(true, response))
            } catch let err {
                completion(DetailResult(false, nil))
                print("Err", err)
            }
        }
        // execute the HTTP request
        task.resume()

    }
}
