//
//  DetailViewController.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import UIKit

protocol DetailViewModelProtocol: AnyObject {
    var delegate: DetailViewModelDelegate? { get set }
    func viewDidLoad()
    func getCachedImage(imdbId: String, completion: ((Data?, Error?) -> Void)?)
}

class DetailViewController: UIViewController {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewModel: DetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    var movie: MovieModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Movie Detail"
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(containerView)
        containerView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -50).isActive = true
        containerView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 20).isActive = true
        containerView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -20).isActive = true
        
        containerView.addSubview(posterImageView)
        posterImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 450).isActive = true
        posterImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        
        containerView.addSubview(yearLabel)
        yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        yearLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        yearLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        yearLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    }

}

//MARK: View Model Delegate Methods
extension DetailViewController: DetailViewModelDelegate {
    func configure(with movie: MovieModel) {
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        
        if let id = movie.imdbId {
            viewModel.getCachedImage(imdbId: id) { data, error in
                if let data {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: data)
                    }
                } else if let error {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}
