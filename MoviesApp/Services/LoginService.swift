//
//  LoginService.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import Foundation

final class LoginService {
    var userName: String?
    var password: String?

    func logUser(_ completion: @escaping (_ result: Result) -> Void) {
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            let success = self.userName?.compare(AppStrings.userName.rawValue) == .orderedSame && self.password?.compare(AppStrings.password.rawValue) == .orderedSame
            UserDefaults.standard.set(true, forKey: "userIsLogged")
            completion(Result(success, nil))
        }
    }
}
