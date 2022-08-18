//
//  NetworkDataFetch.swift
//  itunesTest
//
//  Created by admin on 17.08.2022.
//

import Foundation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    private init() {}
    
    func fetchAlbums(urlString: String, response: @escaping (AlbumModel?, Error?) -> Void) {
        
        NetworkRequest.shared.requestData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let album = try JSONDecoder().decode(AlbumModel.self, from: data)
                    response(album, nil)
                } catch {
                    print("error JSONdecoding")
                }
                
            case .failure(let error):
                print("error:\(error.localizedDescription)")
                response(nil, error)
            }
        }
    }
}
