//
//  CryptoHelper.swift
//  EasyNews
//
//  Created by Mohamed Ali on 28/01/26.
//


import Foundation
import CryptoKit
import UIKit

class CryptoHelper {
    
    static func getDeviceKey() -> SymmetricKey?{
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else {return nil}
        let keyData = Data(deviceID.utf8)
        
        let hashKey = SHA256.hash(data: keyData)
        return SymmetricKey(data: hashKey)
    }
    
    static func encrypt(_ text: String, key: SymmetricKey) -> String?{
        guard let data = text.data(using: .utf8) else{ return nil}
        
        if let sealedBox = try? AES.GCM.seal(data, using: key){
            return sealedBox.combined?.base64EncodedString()
        }
        
        return nil
    }
    
    static func decrypt(_ base64String: String, key: SymmetricKey) -> String?{
        guard let data = Data(base64Encoded: base64String),
              let sealedBox = try? AES.GCM.SealedBox(combined: data) else { return nil}
        if let decryptedData = try? AES.GCM.open(sealedBox, using: key){
            return String(data: decryptedData, encoding: .utf8)
        }
        return nil
    }
    
}
