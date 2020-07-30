
import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift


class FeedRecordRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var sourceId: Int = 0
    @objc dynamic var publishDate: Int = 0
    @objc dynamic var type: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}

//enum PostType {
//    case photo
//    case post
//}
//
//class PhotoFeedType: Object {
//    @objc var id: Int = 0
//    @objc dynamic var ownerId: Int = 0
//    @objc var photoUrl: String = ""
//
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//}
//
//class PostFeedType: Object {
//    @objc dynamic var id: Int = 0
//    @objc dynamic var ownerId: Int = 0
//    @objc dynamic var publishDate: Int = 0
//    @objc dynamic var text: String = ""
//    @objc dynamic var photoUrl: String = ""
//    @objc dynamic var isLikedByMe: Bool = false
//    @objc dynamic var likesCount: Int = 0
//    @objc dynamic var commentsCount: Int = 0
//    @objc dynamic var reportsCount: Int = 0
//    @objc dynamic var viewsCount: Int = 0
//
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//}
