//
//  LoginViewModelType.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import UIKit

protocol LoginViewModelType: ViewModelType {
    var state: LoginState { get }

    func setUsername(_ userName: String?)
    func setPassword(_ password: String?)
    func logUser(vc: UIViewController)
}

enum LoginState: ViewModelStateType {
    case idle, started(fieldsFilled: Bool)
}

