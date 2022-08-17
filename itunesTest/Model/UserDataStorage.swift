//
//  UserDataStorage.swift
//  itunesTest
//
//  Created by admin on 14.08.2022.
//

import Foundation

class UserDataStorage {
    
    static let shared = UserDataStorage()
    
    //replace to Constants
    enum UserKeys: String {
        case users
        case activeUser
    }
    
    let userDefaults = UserDefaults.standard
    let userKey = UserKeys.users.rawValue
    let activeUserKey = UserKeys.activeUser.rawValue
    
    
    //storage for all users
    var users: [UserModel] {
        get {
            if let data = userDefaults.value(forKey: userKey) as? Data {
                do {
                    let user = try PropertyListDecoder().decode([UserModel].self, from: data)
                    return user
                } catch {
                    print("Error")
                }
            }
            return []
        }
        //encode newValue data and save into userDefaults
        set {
            guard let data = try? PropertyListEncoder().encode(newValue) else { return }
            userDefaults.set(data, forKey: userKey)
        }
    }
    
    
    
        func saveUserData(name: String,
                          secondName: String,
                          birth: Date,
                          phone: String,
                          email: String,
                          password: String) {
            let user = UserModel(name: name,
                                 secondName: secondName,
                                 birth: birth,
                                 phone: phone,
                                 email: email,
                                 password: password)
            self.users.append(user)
            print("user saved")
        }
    
    
    
        var activeUser: UserModel? {
            get {
                guard let data = userDefaults.value(forKey: activeUserKey) as? Data else {
                    return nil
                }
                let activeUserModel = try! PropertyListDecoder().decode(UserModel.self, from: data)
                return activeUserModel
            }
            set {
                guard let data = try? PropertyListEncoder().encode(newValue) else {return}
                userDefaults.set(data, forKey: activeUserKey)
            }
        }
    
    //every time after signUp re-writing activeUser (so we have only one)
        func saveActiveUser(_ activeUser: UserModel) {
            self.activeUser = activeUser
        }
    
}
