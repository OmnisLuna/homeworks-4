import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class PhotoRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var url: String?
    @objc dynamic var isLikedByMe: Bool = false
    @objc dynamic var likesCount: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

struct PhotoResponse: Decodable {
    let response: PhotoItems
}

struct PhotoItems: Decodable {
    let items: [Photo]
}

struct Photo: Decodable {
    let id: Int
    let ownerId: Int
    let sizes: [PhotoSizes]
    let likes: PhotoLikes
}

struct PhotoLikes: Decodable {
    let userLikes: Int
    let count: Int
}

struct PhotoSizes: Decodable {
    let height: Int
    let url: String
    let width: Int
    
    var heightCG: CGFloat {
        return CGFloat(height)
    }
    var widhtCG: CGFloat {
        return CGFloat(width)
    }
    var aspectRatio: CGFloat { return CGFloat(height)/CGFloat(width) }
}
