//
//  DashboardViewController.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import UIKit

protocol DashboardViewModelProtocol: AnyObject {
    var delegate: DashboardViewModelDelegate? { get set }
    func viewDidLoad()
    func downloadImage(with urlString: String, imdbId: String, completion: ((Data?, Error?) -> Void)?)
}

class DashboardViewController: UIViewController {
    
    private var tableView = UITableView()
    
    private var models: [MovieModel] = []
        
    var viewModel: DashboardViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        title = "Movies"
        viewModel.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidLoad()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        view.addSubview(tableView)
    }
    

}

//MARK: View Model Delegate Methods
extension DashboardViewController: DashboardViewModelDelegate {
    func didFetchMovies(_ output: [MovieModel]) {
        models = output
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        return cell
    }
}

//MARK: Table View Delegate Methods
extension DashboardViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
