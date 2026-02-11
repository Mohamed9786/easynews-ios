//
//  AuthError.swift
//  EasyNews
//
//  Created by Mohamed Ali on 27/01/26.
//

import Foundation

enum AuthError: LocalizedError{
    case emptyEmail
    case emptyName
    case emptyPass
    
    var errorDescription: String?{
        switch self{
        case .emptyEmail:
            return "Please enter email address"
        case .emptyName:
            return "Please enter username"
        case .emptyPass:
            return "Please enter password"
        }
    }
}
