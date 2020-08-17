import UIKit

class NewsViewController: UITableViewController {
    
    private var myNews = Array<NewRecord>()
    private var startFrom: String = ""
    private var imageService: ImageService?
    let queueGroup = DispatchGroup()
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        tableView.dataSource = self
        requestData()
        imageService = ImageService(container: tableView)
        setupRefreshControl()
                tableView.prefetchDataSource = self
    }
    
    fileprivate func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews() {
        self.refreshControl?.beginRefreshing()
        let mostFreshNewsDate = self.myNews.first?.date ?? Int(Date().timeIntervalSince1970)
        Requests.go.getNews(startTime: (mostFreshNewsDate + 1)) { [weak self] result, nextFrom in
            guard let self = self else { return }
            self.refreshControl?.endRefreshing()
            switch result {
            case .success(let news):
                guard news.items.count > 0 else { return }
                self.myNews = news.items + self.myNews
                var indexPathes : [IndexPath] = []
                for i in 0..<(news.items.count) {
                    indexPathes.append(IndexPath(row: i, section: 0))
                }
                self.queueGroup.notify(queue: DispatchQueue.main) {
                    self.tableView.insertRows(at: indexPathes, with: .automatic)
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private func requestData() {
        Requests.go.getNews() { [weak self] result, nextFrom in
            guard let self = self else { return }
            self.isLoading = true
            switch result {
            case .success(let news):
                self.myNews = news.items
                self.isLoading = false
                
            case .failure(let error):
                self.isLoading = false
                print(error)
            }
            self.queueGroup.notify(queue: DispatchQueue.main) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCard = myNews[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepostNewsCard", for: indexPath) as! RepostNewsCard
        
        cell.postOwnerAvatar.image = imageService?.photo(atIndexpath: indexPath, byUrl: newsCard.sourceAvatar)
        let ph = newsCard.copyHistory?[0].attachments?[0].photo?.sizes[1].url
        cell.repostPhoto.image = imageService?.photo(atIndexpath: indexPath, byUrl: ph ?? "placeholder-1-300x200.png")
        cell.repostSourceAvatar.image = imageService?.photo(atIndexpath: indexPath, byUrl: newsCard.copyHistory?[0].sourceAvatar ?? "placeholder-1-300x200.png")
        
        cell.configure(with: newsCard)
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        switch indexPath.row {
    //        // Ячейки с фото у нас, например, имеют .row == 2
    //        case 2:
    //                // Вычисляем высоту
    //                let tableWidth = tableView.bounds.width
    //                let news = self.myNews[indexPath.section]
    //                let aspectRatio = (news.copyHistory?[0].attachments?[0].photo?.sizes[1].aspectRatio)!
    //                let cellHeight = tableWidth * aspectRatio
    //                return cellHeight
    //        default:
    //        // Для всех остальных ячеек оставляем автоматически определяемый размер
    //                return UITableView.automaticDimension
    //
    //        }
    //    }
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let max = indexPaths.map({ $0.row }).max() else { return }
        if max > (myNews.count - 5) {
            
            if !isLoading {
                isLoading = true
                Requests.go.getNews(startFrom: startFrom) { [weak self] result, nextFrom in
                    guard let self = self else { return }
                    switch result {
                    case .success(let news):
                        guard news.items.count > 0 else { return }
                        let oldIndex = self.myNews.count
                        self.myNews =  self.myNews + news.items
                        self.startFrom = news.nextFrom
                        
                        var indexPathes : [IndexPath] = []
                        for i in oldIndex..<(self.myNews.count){
                            indexPathes.append(IndexPath(row: i, section: 0))
                        }
                        self.tableView.insertRows(at: indexPathes, with: .automatic)
                        self.isLoading = false
                    case .failure(let error):
                        self.isLoading = false
                        print(error)
                    }
                }
            }
        }
    }
}
