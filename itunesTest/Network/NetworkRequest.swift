//
//  NetworkRequest.swift
//  itunesTest
//
//  Created by admin on 17.08.2022.
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init() {}
    
    //completion for error handling
    //Result<type, type> has 2 conditions (succces & error)
    func requestData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let safeData = data else { return }
                completion(.success(safeData))
            }
        }
        task.resume()
    }
    
    
}

