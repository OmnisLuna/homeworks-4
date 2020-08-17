
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
        cell.ownerName.text = newsCard.sourceName
        
        cell.postOwnerAvatar.image = imageService?.photo(atIndexpath: indexPath, byUrl: newsCard.sourceAvatar)
        
        let ph = newsCard.copyHistory?[0].attachments?[0].photo?.sizes[1].url
        cell.repostPhoto.image = imageService?.photo(atIndexpath: indexPath, byUrl: ph ?? "placeholder-1-300x200.png")
        if cell.repostPhoto.image == nil {
            cell.repostPhoto.isHidden = true
        } else {
            cell.repostPhoto.isHidden = false
        }
        
        if (cell.repostSourceName.text == nil && cell.repostSourceAvatar.image == nil) {
            cell.repostSourceName.isHidden = true
            cell.repostSourceAvatar.isHidden = true
            cell.repostSourceDate.isHidden = true
        } else {
            cell.repostSourceName.isHidden = false
            cell.repostSourceAvatar.isHidden = false
            cell.repostSourceDate.isHidden = false
        }
        
        cell.publishDate.text = DateConverter.get.convertDate(newsCard.date)
        cell.postDescription.text = newsCard.text
        cell.viewsCount.text = "\(newsCard.views.count)"
        cell.likesCount.text = "\(newsCard.likes.count)"
        cell.commentsCount.text = "\(newsCard.comments.count)"
        cell.sharingCount.text = "\(newsCard.reposts.count)"
        
        cell.repostDescription.text = newsCard.copyHistory?[0].text
//        cell.repostSourceAvatar.image = imageService?.photo(atIndexpath: indexPath, byUrl: newsCard.copyHistory?[0].sourceAvatar ?? "placeholder-1-300x200.png")
//        cell.repostSourceName.text = newsCard.copyHistory?[0].sourceName
        cell.repostSourceDate.text = DateConverter.get.convertDate(newsCard.copyHistory?[0].date ?? 0)
        return cell
    }
}
