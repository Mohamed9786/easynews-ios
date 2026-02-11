//
//  PinnedSessionDelegate.swift
//  EasyNews
//
//  Created by Mohamed Ali on 05/02/26.
//

import UIKit
import Security

class PinnedSession: NSObject, URLSessionTaskDelegate {
    private static let pinnedData: Data? = {
        guard let url = Bundle.main.url(forResource: "newsapi", withExtension: "cer"),
              let data = try? Data(contentsOf: url)
        else{
            print("PinnedData is nil")
            return nil
        }
        return data
    } ()
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ){
        guard
            challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            let serverTrust = challenge.protectionSpace.serverTrust else{
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let serverCertificateData = SecCertificateCopyData(certificate) as Data
        
        if let pinnedData = PinnedSession.pinnedData, serverCertificateData == pinnedData{
            print("Certificate match Found")
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else{
            print("Certificate match Failed")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
}
