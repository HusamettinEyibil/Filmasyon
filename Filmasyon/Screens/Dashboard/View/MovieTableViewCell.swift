//
//  MovieTableViewCell.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 14.07.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    static let identifier = "MovieTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.corner(3)
        view.border(.lightGray, 1)
        view.backgroundColor = .white
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
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
        containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7).isActive = true
        containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        
        containerView.addSubview(posterImageView)
        posterImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        posterImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        posterImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        
        containerView.addSubview(yearLabel)
        yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        yearLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        yearLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor).isActive = true
        yearLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
    }
    
    func configureCell(with movie: MovieModel) {
        selectionStyle = .none
        backgroundColor = .white
        titleLabel.text = movie.title
        yearLabel.text = "Release Date: \(movie.year ?? "")"
    }
    
    func setImage(with data: Data) {
        posterImageView.image = UIImage(data: data)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
