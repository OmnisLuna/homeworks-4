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
    
}
