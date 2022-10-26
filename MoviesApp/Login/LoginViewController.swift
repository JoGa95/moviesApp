//
//  LoginViewController.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    private let viewModel: LoginViewModelType
    private typealias Text = AppStrings.LoginScreen

    init(viewModel: LoginViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.didChange = { [weak self] in
            self?.configure()
        }
        viewModel.start()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupViews() {
        loginButton.setTitle(Text.loginButton.rawValue , for: .normal)
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func configure() {
        switch viewModel.state {
        case .idle:
            setupButtons(false)
        case .started(let fieldsFilled):
            setupButtons(fieldsFilled)
        }
    }

    private func setupButtons(_ fieldsFilled: Bool) {
        loginButton.backgroundColor = fieldsFilled ? .appColor(.darkBlue) : .appColor(.darkGray)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == userNameTextField {
            viewModel.setUsername(textField.text)
        } else {
            viewModel.setPassword(textField.text)
        }
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        viewModel.logUser(vc: self)
    }
}
