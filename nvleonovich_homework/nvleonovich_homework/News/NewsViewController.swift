
import UIKit
import SDWebImage
import RealmSwift

class NewsViewController: UITableViewController {

    private var myNews = Array<NewRecord>()
    private var users = Array<User>()
    var token: NotificationToken?
    private var imageService: ImageService?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        tableView.dataSource = self
        requestData()
        imageService = ImageService(container: tableView)
    }
    
    private func requestData() {
        Requests.go.getNews { [weak self] result in
            switch result {
            case .success(let news):
                self?.myNews = news.items
            case .failure(let error):
                print(error)
            }
            self?.tableView.reloadData()
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
}
