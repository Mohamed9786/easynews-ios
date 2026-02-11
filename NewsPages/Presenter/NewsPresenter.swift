import Foundation

protocol NewsPresenterDelegate: AnyObject{
    func didUpdateArticles()
    func didFailWithError(_ error: Error)
    func didNotAcceptQuery(_ error: String)
    
}
class NewsPresenter{
    weak var delegate: NewsPresenterDelegate?
    var articles = [Articles]()
    var currentQuery = "Software"
    
    func loadNews(query: String?, page: Int){
        if let newQuery = query {
            self.currentQuery = newQuery
            if page == 1 { articles.removeAll() }
        }
        
        NewsService.shared.fetchApi(query: currentQuery, page: page){ [weak self] result in
            switch result {
            case .success(let fetchArticles):
                if fetchArticles.count > 0{
                    self?.articles.append(contentsOf: fetchArticles)
                    self?.delegate?.didUpdateArticles()
                    print("Articles:", self?.articles)
                } else{
                    self?.delegate?.didNotAcceptQuery("Failed to load")
                    print("Failed to load")
                }
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }
    }
    
    func getArticle(at index: Int)-> Articles{
        articles[index]
    }
    var numberOfArticles: Int{
        articles.count
    }
    func getAllArticles() -> [Articles]{
        articles
    }
}
