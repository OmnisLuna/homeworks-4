
import UIKit
import SDWebImage
import RealmSwift

class NewsViewController: UITableViewController {

    private var myNews = Array<FeedRecord>()
    private var sourceDetails = Array<SourceDetails>()
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
        Requests.go.getNews { [weak self] news, sourceDetails in
            self?.myNews = news
            self?.sourceDetails = sourceDetails
            self?.tableView.reloadData()
        }
    }
    
    private func getSourceName(_ index: Int) -> String {
        var name = ""
        for source in sourceDetails {
            if source.id == myNews[index].sourceId {
                name = source.name
            }
        }
        return name
    }
    
    private func getSourceAvatar(_ index: Int) -> String {
        var avatar = ""
        for source in sourceDetails {
            if source.id == myNews[index].sourceId {
                avatar = source.avatar
            }
        }
        return avatar
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCard = myNews[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCard", for: indexPath) as! NewsCard
        cell.ownerName.text = getSourceName(indexPath.row)
        let avatar = getSourceAvatar(indexPath.row)
        
        cell.postOwnerAvatar.image = imageService?.photo(atIndexpath: indexPath, byUrl: avatar )
        cell.postPhoto.image = imageService?.photo(atIndexpath: indexPath, byUrl: newsCard.photo ?? "placeholder-1-300x200.png")
//        cell.postPhoto.image = myNews[indexPath.row].photo
    
//        cell.publishDate.text = convertDate(newsCard.publishDate)
        cell.publishDate.text = DateConverter.get.convertDate(newsCard.publishDate)
        cell.postDescription.text = newsCard.text
        cell.viewsCount.text = "\(newsCard.viewsCount)"
        cell.likesCount.text = "\(newsCard.likesCount)"
        cell.commentsCount.text = "\(newsCard.commentsCount)"
        cell.sharingCount.text = "\(newsCard.reportsCount)"
        return cell
    }
}
