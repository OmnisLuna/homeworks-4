import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

//struct Photo {
//    //фотография
//    let id: Int
//    let ownerId: Int
//    var url: String
//    var isLikedByMe: Bool
//    var likesCount: Int
    
//    init(json: JSON) {
//        self.id = json["id"].intValue
//        self.ownerId = json["owner_id"].intValue
//        self.url = json["sizes"][3]["url"].stringValue
//        self.isLikedByMe = json["likes"]["user_likes"].boolValue
//        self.likesCount = json["likes"]["count"].intValue
//    }
//}

class PhotoRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var isLikedByMe: Bool = false
    @objc dynamic var likesCount: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
