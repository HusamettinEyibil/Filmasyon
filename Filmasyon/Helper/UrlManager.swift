//
//  UrlManager.swift
//  Filmasyon
//
//  Created by Hüsamettin  Eyibil on 15.07.2023.
//

import Foundation

struct UrlManager {
    private let baseUrl = "https://www.omdbapi.com"
    
    func getSearchUrl(for searchKey: String) -> URL? {
        if let url = URL(string: "\(baseUrl)/?apikey=\(API_KEY)&s=\(searchKey)") {
            return url
        } else {
            return nil
        }
    }
}
