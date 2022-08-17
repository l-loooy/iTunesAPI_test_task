//
//  UserDataModel.swift
//  itunesTest
//
//  Created by admin on 14.08.2022.
//

import Foundation

struct UserModel: Codable {
    let name: String
    let secondName: String
    let birth: Date
    let phone: String
    let email: String
    let password: String
}
