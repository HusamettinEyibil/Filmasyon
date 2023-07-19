//
//  MovieModel.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import Foundation

struct MovieResponseModel: Decodable {
    var totalResults: String
    var searchResults: [MovieModel]
    
    enum CodingKeys: String, CodingKey {
        case totalResults
        case searchResults = "Search"
    }
}

struct MovieModel: Decodable {
    var title: String?
    var year: String?
    var imdbId: String?
    var type: String?
    var posterUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbId = "imdbID"
        case type
        case posterUrl = "Poster"
    }
}
