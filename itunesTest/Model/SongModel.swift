//
//  SongModel.swift
//  itunesTest
//
//  Created by admin on 18.08.2022.
//

import Foundation


struct SongModel: Decodable {
    let results: [Song]
}


struct Song: Decodable {
    let trackName: String?
}
