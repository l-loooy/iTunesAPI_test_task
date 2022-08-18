//
//  AlbumModel.swift
//  itunesTest
//
//  Created by admin on 17.08.2022.
//


//    •    Экран альбома.
//    •    Обязательно для отображения:
//    •    лого альбома
//    •    название альбома
//    •    название группы
//    •    год выхода альбома
//    •    список песен
//         

import Foundation

struct AlbumModel: Decodable {
    let results: [Album]
    
}


struct Album: Decodable {
    let artistName: String
    let collectionName: String
    let releaseDate: String
    // if album has no cover app will crush
    let artworkUrl100: String?
    let trackCount: Int
    
    let collectionId: Int
    
}
