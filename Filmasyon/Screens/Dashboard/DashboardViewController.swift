//
//  DashboardViewController.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import UIKit

protocol DashboardViewModelProtocol: AnyObject {
    var delegate: DashboardViewModelDelegate? { get set }
    func searchMovies(completion: @escaping (Result<([MovieModel], Int?), NetworkError>) -> Void)
    func didSelectRow(at indexPath: IndexPath)
    func downloadImage(with urlString: String, imdbId: String, completion: ((Data?, Error?) -> Void)?)
}

class DashboardViewController: BaseViewController {
    
    private var searchBar = UISearchBar()
    private var tableView = UITableView()
    
    private var models: [MovieModel] = []
    private var totalResults = 0
        
    var viewModel: DashboardViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Movies"
        fetchMovies()
        configureTableView()
        configureSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 20).isActive = true
        searchBar.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -20).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 20).isActive = true
        tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -20).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        tableView.reloadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        viewModel.viewDidLoad()
//    }
    
    func fetchMovies() {
        viewModel.searchMovies() { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                let movies = response.0
                handleSearchResults(with: movies)
                totalResults = response.1 ?? 0
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func handleSearchResults(with movies: [MovieModel]) {
        models.append(contentsOf: movies)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
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
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            preconditionFailure("Cell identifier could not be found.")
        }
        
        let movie = models[indexPath.row]
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
        
        if indexPath.row == models.count - 1 {
            if totalResults > models.count {
                fetchMovies()
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
    
}
