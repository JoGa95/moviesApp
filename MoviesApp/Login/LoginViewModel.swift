//
//  LoginViewModel.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import UIKit

final class LoginViewModel: BaseViewModel<LoginState>, LoginViewModelType {
    private let loginService: LoginService

    init(loginService: LoginService) {
        self.loginService = loginService
    }

    override func start() {
        if case .idle = state {
            updateState()
        }
    }

    private func updateState() {
        state = .started(fieldsFilled: loginService.userName?.isEmpty == false && loginService.password?.isEmpty == false)
    }

    func setUsername(_ username: String?) {
        loginService.userName = username
        updateState()
    }

    func setPassword(_ password: String?) {
        loginService.password = password
        updateState()
    }

    func logUser(vc: UIViewController) {
        vc.showLoader()
        loginService.logUser { result in
            vc.hideLoder()
            if result.success {
                let viewModel = MoviesViewModel(moviesService: MoviesService())
                vc.pushViewController(viewController: MoviesViewController(viewModel: viewModel))
            } else {
                vc.showAlert(message: AppStrings.LoginScreen.loginError.rawValue)
            }
        }
    }

}
