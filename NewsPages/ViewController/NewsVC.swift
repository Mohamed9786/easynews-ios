import UIKit

class NewsVC: UIViewController{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    let presenter = NewsPresenter()
    var filteredItems: [Articles] = []
    var allItem: [Articles] = []
    var currentPage = 1
    var moreData = true
    var currentCategory = "Breaking News"
    @IBOutlet weak var failShow: UILabel!
    //let helper = newsCategory.shared
    //let userdefault = SecureVault.shared
    let category = ["Breaking News", "Business", "Technology", "Politics", "Sports"]
    
    /*
    @IBAction func categoryBtn(_ sender: Any) {
        let sb = UIStoryboard(name: "NewsPage", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "CategoryAddVC") as? CategoryAddVC{
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.onCategoryAdded = { [weak self] newText in
                self?.helper.category.insert(newText, at: 0)
                self?.userdefault.saveCategory()
                self?.collectionView.reloadData()
            }
            self.present(vc, animated: true, completion: nil)
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //userdefault.defaultCategorySetUp()
        presenter.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        failShow.isHidden = true
        setupUI()
        startLoading()
        presenter.loadNews(query: currentCategory, page: 1)
        tableView.accessibilityIdentifier = "tableView"
        self.navigationController?.navigationBar.accessibilityIdentifier = "navBar"
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func setupUI(){
        self.navigationItem.hidesBackButton = true
        
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func navToProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let vc = storyboard.instantiateViewController(identifier: "ProfileVC") as? ProfileVC{
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

extension NewsVC: NewsPresenterDelegate {
    func didUpdateArticles() {
        allItem = presenter.getAllArticles()
        filteredItems = allItem
        DispatchQueue.main.async {
            self.stopLoading()
            self.tableView.reloadData()
            if self.currentPage == 1 && !self.filteredItems.isEmpty {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    func didFailWithError(_ error: Error) {
        moreData = false
        DispatchQueue.main.async {
            self.loading.stopAnimating()
            self.loading.isHidden = true
        }
        print("API Failure: ", error)
    }
    func didNotAcceptQuery(_ error: String) {
        if self.currentPage == 1{
            DispatchQueue.main.async {
                self.loading.stopAnimating()
                self.loading.isHidden = true
                self.failShow.isHidden = false
            }
        }
    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsTableViewCell else {
                return UITableViewCell()
            }
        let item = filteredItems[indexPath.row]
        cell.title.text = item.title
        cell.urlimage.loadImage(from: item.urlToImage)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let homeStoryboard = UIStoryboard(name: "NewsPage", bundle: nil)
        if let destinationVC = homeStoryboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC{
            destinationVC.selectedArticle = presenter.getArticle(at: indexPath.row)
            
            if let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
                destinationVC.loadViewIfNeeded()
                destinationVC.newsImage.image = cell.urlimage.image
                destinationVC.backgroundImage.image = cell.urlimage.image
            }
            
            destinationVC.modalPresentationStyle = .pageSheet
            self.present(destinationVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == allItem.count - 2 && moreData{
            print("Checked more data")
            getData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty{
            filteredItems = allItem
        } else{
            filteredItems = allItem.filter { item in
                return item.title.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func getData() {
        print("Get Data called here")
        moreData = true
        currentPage += 1
        presenter.loadNews(query: currentCategory, page: currentPage)
    }
    
    func startLoading() {
        loading.startAnimating()
        tableView.isHidden = true
    }

    func stopLoading() {
        loading.stopAnimating()
        tableView.isHidden = false
    }
    
}

extension NewsVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "softwareCell", for: indexPath) as! CollectionViewCell
        let categoryName = category[indexPath.row]
        cell.label.text = categoryName
        cell.contentView.isUserInteractionEnabled = false
        
        if categoryName == currentCategory {
                cell.backgroundColor = .systemBlue
                cell.label.textColor = .white
        } else {
            cell.backgroundColor = .systemGray6
            cell.label.textColor = .label
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection Clicking")
        self.failShow.isHidden = true
        let selectedCategory = category[indexPath.row]
        guard selectedCategory != currentCategory else { return }
        self.currentCategory = selectedCategory
        self.currentPage = 1
        self.moreData = true
        collectionView.reloadData()
        startLoading()
        presenter.loadNews(query: currentCategory, page: 1)
        
    }
}


class CollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var label: UILabel!
}
