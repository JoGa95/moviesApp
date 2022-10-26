//
//  MoviesDetailViewController.swift
//  MoviesApp
//
//  Created by Jorge Garay on 25/10/22.
//

import UIKit

class MoviesDetailViewController: UIViewController {
    @IBOutlet weak var firstDataLabel: UILabel!
    @IBOutlet weak var secondDataLabel: UILabel!
    @IBOutlet weak var thirdDataLabel: UILabel!
    @IBOutlet weak var fourthDataLabel: UILabel!
    @IBOutlet weak var fifthDataLabel: UILabel!
    @IBOutlet weak var sixthDataLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var companiesCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoritesImage: UIImageView!

    private let viewModel: MoviesDetailViewModelType
    private var moviesData: MoviesDetailState.MoviesDetailData?
    private var movieNetworks: [NetworkData] = []

    init(viewModel: MoviesDetailViewModelType) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setupViews() {
        navigationItem.backButtonTitle = ""
        navigationItem.title = "Detail show"
        setupNavigationBarColor(backgroundColor: .appColor(.backgroundNavigationBar))
    }

    private func setupCollectionView() {
        companiesCollectionView.backgroundColor = .black
        companiesCollectionView.register(UINib(nibName: "MoviesDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoviesDetailCell")
        companiesCollectionView.delegate = self
        companiesCollectionView.dataSource = self
        companiesCollectionView.isScrollEnabled = true
    }

    private func configure() {
        switch viewModel.state {
        case .idle:
            setupViews()
            showLoader()
        case .started(let moviesData):
            DispatchQueue.main.async {
                self.hideLoder()
                self.moviesData = moviesData
                self.movieNetworks = moviesData.networks
                self.populateData(moviesData)
                self.companiesCollectionView.reloadData()
            }
        }
    }

    private func populateData(_ data: MoviesDetailState.MoviesDetailData) {
        let Text = AppStrings.MoviesDetailScreen.self
        let url = URL(string: API.urlImages.rawValue + data.image)!
        detailImageView.downloaded(from: url)
        firstDataLabel.text = String(format: Text.name.rawValue, data.title)
        secondDataLabel.text = String(format: Text.date.rawValue, data.date)
        thirdDataLabel.text = String(format: Text.rating.rawValue, String(data.rating))
        fourthDataLabel.text = String(format: Text.description.rawValue,  data.description)
        fifthDataLabel.text = String(format: Text.numberSeasons.rawValue, String(data.numberSeasons))
        sixthDataLabel.text = String(format: Text.numberEpisodes.rawValue, String(data.numberEpisodes))
        titleLabel.text = Text.title.rawValue
    }

}

extension MoviesDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.movieNetworks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = companiesCollectionView.dequeueReusableCell(withReuseIdentifier: "MoviesDetailCell",
                                                            for: indexPath) as? MoviesDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(model: movieNetworks[indexPath.row])
        return cell
    }

}
