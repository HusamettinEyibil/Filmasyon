//
//  DashboardViewController.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import UIKit

enum SearchType {
    case TableView
    case CollectionView
}

protocol DashboardViewModelProtocol: AnyObject {
    var delegate: DashboardViewModelDelegate? { get set }
    func searchMovies(type: SearchType, isNewSearch: Bool, completion: @escaping (Result<([MovieModel], Int?), NetworkError>) -> Void)
    func didSelectRow(at indexPath: IndexPath)
    func didSelectItem(at indexPath: IndexPath)
    func setSearchKey(with key: String)
    func downloadImage(with urlString: String, imdbId: String, completion: ((Data?, Error?) -> Void)?)
}

class DashboardViewController: BaseViewController {
    
    private var searchBar = UISearchBar()
    private var tableViewContainer = UIView()
    private var tableView = UITableView()
    private var collectionView: UICollectionView!
    
    private var tableModels: [MovieModel] = []
    private var collectionModels: [MovieModel] = []
    private var totalResultsForTable = 0
    private var totalResultsForCollection = 0
    private var searchText = "star"
        
    var viewModel: DashboardViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Movies"
        fetchMovies(with: searchText, type: .TableView, isNewSearch: true)
        fetchMovies(with: "Comedy", type: .CollectionView)
        configureTableView()
        configureSearchBar()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 20).isActive = true
        searchBar.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -20).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(tableViewContainer)
        tableViewContainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        tableViewContainer.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 20).isActive = true
        tableViewContainer.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -20).isActive = true
        
        tableViewContainer.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor, constant: 4).isActive = true
        tableView.leftAnchor.constraint(equalTo: tableViewContainer.leftAnchor, constant: 4).isActive = true
        tableView.rightAnchor.constraint(equalTo: tableViewContainer.rightAnchor, constant: -4).isActive = true
        tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor, constant: -6).isActive = true
        
        tableView.reloadData()
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: tableViewContainer.bottomAnchor, constant: 10).isActive = true
        collectionView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 20).isActive = true
        collectionView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 220).isActive = true
    }
    
    func fetchMovies(with searchKey: String, type: SearchType, isNewSearch: Bool = false) {
        viewModel.setSearchKey(with: searchKey)
        viewModel.searchMovies(type: type, isNewSearch: isNewSearch) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                let movies = response.0
                handleSearchResults(with: movies, for: type, isNewSearch: isNewSearch)
                if type == .TableView {
                    totalResultsForTable = response.1 ?? 0
                } else {
                    totalResultsForCollection = response.1 ?? 0
                }
            case let .failure(error):
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(with: "No results for this search key. Please try another one.")
                }
            }
        }
    }
    
    func handleSearchResults(with movies: [MovieModel], for type: SearchType, isNewSearch: Bool) {
        switch type {
        case .TableView:
            if isNewSearch {
                tableModels = movies
            } else {
                tableModels.append(contentsOf: movies)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        case .CollectionView:
            if isNewSearch {
                collectionModels = movies
            } else {
                collectionModels.append(contentsOf: movies)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func configureTableView() {
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainer.corner(5)
        tableViewContainer.backgroundColor = UIColor(red: 0.93, green: 0.8, blue: 0.93, alpha: 1)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.corner(5)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
    
    func configureSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .search
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
    }
    
    func endEditing() {
        view.endEditing(true)
    }
    
}

//MARK: View Model Delegate Methods
extension DashboardViewController: DashboardViewModelDelegate {
    func showDetail(for movie: MovieModel) {
        let viewController = DetailBuilder.build(movie: movie)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: Table View Data Source Methods
extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            preconditionFailure("Cell identifier could not be found.")
        }
        
        let movie = tableModels[indexPath.row]
        cell.configureCell(with: movie)
        if let imageUrl = movie.posterUrl, let id = movie.imdbId {
            viewModel.downloadImage(with: imageUrl, imdbId: id) { data, error in
                if let data {
                    DispatchQueue.main.async {
                        cell.setImage(with: data)
                    }
                } else if let error {
                    debugPrint(error.localizedDescription)
                }
            }
        }
        
        if indexPath.row == tableModels.count - 1 {
            if totalResultsForTable > tableModels.count {
                fetchMovies(with: searchText, type: .TableView)
            }
        }
        
        return cell
    }
}

//MARK: Table View Delegate Methods
extension DashboardViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        endEditing()
        viewModel.didSelectRow(at: indexPath)
    }
}

//MARK: Search Bar Delegate Methods
extension DashboardViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let key = searchBar.text {
            searchText = key
            fetchMovies(with: key, type: .TableView, isNewSearch: true)
        }
    }
}

//MARK: Collection View Data Source Methods
extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            preconditionFailure("Cell identifier could not be found.")
        }
        let movie = collectionModels[indexPath.row]
        cell.configureCell(with: movie)
        if let imageUrl = movie.posterUrl, let id = movie.imdbId {
            viewModel.downloadImage(with: imageUrl, imdbId: id) { data, error in
                if let data {
                    DispatchQueue.main.async {
                        cell.setImage(with: data)
                    }
                } else if let error {
                    debugPrint(error.localizedDescription)
                }
            }
        }
        
        if indexPath.row == collectionModels.count - 1 {
            if totalResultsForCollection > collectionModels.count {
                fetchMovies(with: "Comedy", type: .CollectionView)
            }
        }
        
        return cell
    }
}

//MARK: Collection View Delegate Methods
extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        endEditing()
        viewModel.didSelectItem(at: indexPath)
    }
}

//MARK: Collection View Flow Layout Methods
extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: collectionView.frame.size.height)
    }
}
