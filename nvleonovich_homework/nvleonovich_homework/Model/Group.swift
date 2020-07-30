import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

//struct Group {
//    //данные элемента группа
//    let id: Int
//    var name: String
//    var isMember: Int
//    var avatar: String
    
//    init(json: JSON) {
//        self.id = json["id"].intValue
//        self.name = json["name"].stringValue
//        self.isMember = json["is_member"].intValue
//        self.avatar = json["photo_100"].stringValue
//    }
//}

class GroupRealm: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var isMember: Int
    @objc dynamic var avatar: String
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension GroupRealm {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case avatar = "photo_100"
        case isMember = "is_member"
    }
}

struct GroupRealmResponse: Decodable {
    let response: GroupRealmItems
}

struct GroupRealmItems: Decodable {
    let items: [GroupRealm]
}
