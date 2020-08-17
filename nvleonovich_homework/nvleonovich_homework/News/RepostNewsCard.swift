import UIKit

class RepostNewsCard: UITableViewCell {
    
    @IBOutlet weak var postOwnerAvatar: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var repostSourceAvatar: UIImageView!
    @IBOutlet weak var repostSourceName: UILabel!
    @IBOutlet weak var repostSourceDate: UILabel!
    @IBOutlet weak var repostDescription: UILabel!
    @IBOutlet weak var repostPhoto: UIImageView!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var sharingCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var repostSourceStack: UIStackView!
    var newsCard: NewRecord?
    
    func configure(with newsCard: NewRecord) {
        self.newsCard = newsCard
        ownerName.text = newsCard.sourceName
        
        if repostPhoto.image == nil {
            repostPhoto.isHidden = true
        } else {
            repostPhoto.isHidden = false
        }
        
        publishDate.text = DateConverter.get.convertDate(newsCard.date)
        postDescription.text = newsCard.text
        viewsCount.text = "\(newsCard.views.count)"
        likesCount.text = "\(newsCard.likes.count)"
        commentsCount.text = "\(newsCard.comments.count)"
        sharingCount.text = "\(newsCard.reposts.count)"
        
        repostDescription.text = newsCard.copyHistory?[0].text
        repostSourceName.text = newsCard.copyHistory?[0].sourceName
        repostSourceDate.text = DateConverter.get.convertDate(newsCard.copyHistory?[0].date ?? 0)
    }
}
