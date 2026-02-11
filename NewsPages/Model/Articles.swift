//
//  Articles.swift
//  EasyNews
//
//  Created by Mohamed Ali on 23/01/26.
//

import Foundation

nonisolated struct NewsResponse: Decodable{
    let articles: [Articles]
}

struct Articles: Decodable{
    let author: String?
        let title: String
        let url: URL
        let urlToImage: URL?
        let publishedAt: Date
        let content: String?
}
/*
class newsCategory{
    static let shared = newsCategory()
    var category: [String] = [String]()
    private init() {}
}
*/
