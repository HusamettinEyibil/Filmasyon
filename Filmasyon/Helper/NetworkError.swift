//
//  NetworkError.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case failedToGetMovies
    case failedToDecodeData
    case failedToDownloadImage
}
