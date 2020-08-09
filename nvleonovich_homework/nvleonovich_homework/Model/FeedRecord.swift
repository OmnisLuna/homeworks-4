
import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class FeedRecord {
   
    var id: Int = 0
    var sourceId: Int = 0
    var publishDate: Int = 0
    var type: String = ""
    var text: String = ""
    var isLikedByMe: Bool = false
    var likesCount: Int = 0
    var commentsCount: Int = 0
    var reportsCount: Int = 0
    var viewsCount: Int = 0
    var sourceAvatar: String?
    var sourceName: String?
    var postAttachmentsType: PostAttachmentsType?
    var photo: String? = ""
    
    init(json: JSON) {
        self.id = json["post_id"].intValue
        self.sourceId = json["source_id"].intValue
        self.publishDate = json["date"].intValue
        self.type = json["type"].stringValue
        self.text = json["text"].stringValue
        self.isLikedByMe = json["likes"]["user_likes"].boolValue
        self.likesCount = json["likes"]["count"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.reportsCount = json["reposts"]["count"].intValue
        self.viewsCount = json["views"]["count"].intValue
        self.photo = json["attachments"]["photo"]["sizes"][0]["url"].stringValue
    }
}

class SourceDetails {
        var id: Int = 0
        var name: String = ""
        var avatar: String = ""
}

class Photo {
    
}

enum Attachments {
    case photo(Photo)
    case video
    case unknown
}

class CopyHistory {
    var id: Int = 0
    var ownerId: Int = 0
    var fromId: Int = 0
    var publishDate: Int = 0
    var postType: String = ""
    var text: String = ""
    var attachments: [Attachments]?
    
    init(json: JSON) {
        self.id = json["post_id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.fromId = json["from_id"].intValue
        self.publishDate = json["date"].intValue
        self.postType = json["post_type"].stringValue
        self.text = json["text"].stringValue
    }
}
    
enum PostAttachmentsType {
    case attachments(Attachments)
    case copyHistory(CopyHistory)
    case unknown

    var attachments: Attachments? {
        guard case let .attachments(value) = self else { return nil }
        return value
    }

    var copyHistory: CopyHistory? {
        guard case let .copyHistory(value) = self else { return nil }
        return value
    }
}
    

