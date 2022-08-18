//
//  StringExtension.swift
//  itunesTest
//
//  Created by admin on 13.08.2022.
//

import Foundation


extension String {
    
    enum ValidTypes {
        case name
        case email
        case password
    }
    
    //mask
    enum RegEx: String {
        //{1,} means minimum element count is 1, maximum doesn't set
        case name = "[a-zA-Z]{1,}"
        case email = "[a-zA-Z0-9._-]+@[a-zA-Z0-9]+\\.[a-zA-Z]{2,}"
//        Пароль (не менее 6 символов, обязательно должны быть цифра, буква нижнего регистра, буква верхнего регистра)
        case password = "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{6,}"
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .name:
            regex = RegEx.name.rawValue
        case .email:
            regex = RegEx.email.rawValue
        case .password:
            regex = RegEx.password.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
    
}
