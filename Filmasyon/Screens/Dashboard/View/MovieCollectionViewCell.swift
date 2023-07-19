//
//  MovieCollectionViewCell.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 19.07.2023.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.corner(3)
        view.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 0.93, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.corner(3)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3).isActive = true
        
        containerView.addSubview(posterImageView)
        posterImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        posterImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        
        containerView.addSubview(yearLabel)
        yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        yearLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        yearLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        yearLabel.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor, constant: -10).isActive = true
    }
    
    func configureCell(with movie: MovieModel) {
        backgroundColor = .white
        titleLabel.text = movie.title
        yearLabel.text = "Release Date: \(movie.year ?? "")"
    }
    
    func setImage(with data: Data) {
        posterImageView.image = UIImage(data: data)
    }
}
