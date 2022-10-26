//
//  MoviesViewController.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import UIKit

class MoviesViewController: UIViewController {
    @IBOutlet weak var categoriesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    private let viewModel: MoviesViewModelType
    private typealias Text = AppStrings.MoviesScreen
    private var moviesArray: [MoviesState.MoviesData] = []

    init(viewModel: MoviesViewModelType) {
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
        setupCollectionView()
        viewModel.didChange = { [weak self] in
            self?.configure()
        }
        viewModel.start()
    }

    private func configure() {
        switch viewModel.state {
        case .idle:
            setupViews()
        case .started(let moviesData):
            DispatchQueue.main.async {
                self.moviesArray = moviesData
                self.moviesCollectionView.reloadData()
            }
        }
    }

    private func setupViews() {
        navigationItem.hidesBackButton = true
        setupNavigationBarColor(backgroundColor: .appColor(.backgroundNavigationBar))
        let rightView = makeRightButton(Text.screenTitle.rawValue, "ic_list")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
        categoriesSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
    }

    private func setupCollectionView() {
        moviesCollectionView.backgroundColor = .black
        moviesCollectionView.register(UINib(nibName: "MoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoviesCell")
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self

        let flowLayout = UICollectionViewFlowLayout()
        let itemSpacing = 5.0
        let lineSpacing = 5.0
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: lineSpacing, left: lineSpacing, bottom: lineSpacing, right: lineSpacing)
        moviesCollectionView.collectionViewLayout = flowLayout
    }

    @objc private func navigationButtonTapped() {
        showNavigationMenu()
    }

    private func showNavigationMenu() {
        let menu = UIAlertController(title: Text.actionSheetTitle.rawValue, message: nil, preferredStyle: .actionSheet)
        let profileAction = UIAlertAction(title: Text.actionSheetMenu1.rawValue, style: .default) { [weak self] _ in
            self?.showProfileScreen()
        }
        let logOutAction = UIAlertAction(title: Text.actionSheetMenu2.rawValue, style: .default) { [weak self] _ in
            self?.logOutUser()
        }
        logOutAction.setValue(UIColor.red, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: Text.cancel.rawValue, style: .cancel, handler: nil)
        menu.addAction(profileAction)
        menu.addAction(logOutAction)
        menu.addAction(cancelAction)
        present(menu, animated: true, completion: nil)
    }

    private func showProfileScreen() {
        viewModel.showProfileScreen(self)
    }

    private func logOutUser() {
        viewModel.logOutUser(self)
    }

    private func makeRightButton(_ title: String, _ imageName: String) -> UIView {
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 300 , height: 44.0))
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200, height: 44.0))
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        customView.addSubview(label)
        let marginX = CGFloat(label.frame.origin.x + label.frame.size.width + 70)
        let button = UIButton.init(type: .custom)
        button.setBackgroundImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(x: marginX, y: 5.0, width: 32.0, height: 32.0)
        button.addTarget(self, action: #selector(navigationButtonTapped), for: .touchUpInside)
        customView.addSubview(button)
        return customView
    }

    @IBAction func segmentedControllTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.getMovies(API.pathPopular.rawValue, self)
        case 1:
            viewModel.getMovies(API.pathTopRated.rawValue, self)
        case 2:
            viewModel.getMovies(API.pathOnAir.rawValue, self)
        case 3:
            viewModel.getMovies(API.pathAiringToday.rawValue, self)
        default:
            viewModel.getMovies(API.pathPopular.rawValue, self)
        }
    }
}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.moviesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCell",
                                                            for: indexPath) as? MoviesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(model: moviesArray[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.openMovieDetailScreen(self, String(moviesArray[indexPath.row].id))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width

        return CGSize(width: width * 0.45, height: height * 0.4)
    }

}
