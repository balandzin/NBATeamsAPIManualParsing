//
//  NetworkManager.swift
//  NBATeamsAPI
//
//  Created by Антон Баландин on 3.02.24.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchGames(from url: String, completion: @escaping(Result<[Game], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let gameData = Games.getGames(from: value)
                    completion(.success(gameData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
