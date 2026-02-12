//
//  DataHandler.swift
//  EasyNews
//
//  Created by Mohamed Ali on 20/01/26.
//

import Foundation

class NewsService{
    static let shared = NewsService()
    private let sessionDelegate = PinnedSession()
    var session: URLSession!
    
    init() {
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration,
                                  delegate: sessionDelegate,
                                  delegateQueue: nil)
        loadConfig()
    }
    
    var BASE_URL: String = ""
    var API_KEY: String = ""
    
    func loadConfig(){
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) else {
            return
        }
        self.BASE_URL = dict["BASE_URL"] as? String ?? ""
        self.API_KEY = dict["API_KEY"] as? String ?? ""
    }
    
    func fetchApi(query: String, page: Int, completion: @escaping (Result<[Articles], Error>) -> Void){
        loadConfig()
        let urlString: String
        if query == "Breaking News"{
            urlString = "\(BASE_URL)/top-headlines?country=us&pageSize=15&page=\(page)&apiKey=\(API_KEY)"
        }else{
            urlString = "\(BASE_URL)/everything?q=\(query)&pageSize=15&page=\(page)&apiKey=\(API_KEY)"
        }
        print("URL for API:", urlString)
        
        guard let url = URL(string: urlString) else { return }
        
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let data = data {
                do {
                    let response = try decoder.decode(NewsResponse.self, from: data)
                    print("Response: ", response)
                    completion(.success(response.articles))
                }
                catch {
                    let responseString = String(data: data, encoding: .utf8 )
                    print("Data from API: ", responseString)
                    completion(.failure(error))
                    print("Failed: \(error)")
                }
            }
        }.resume()
    }
}
