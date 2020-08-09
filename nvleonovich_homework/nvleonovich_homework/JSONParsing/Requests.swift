import SwiftyJSON
import Alamofire
import RealmSwift

enum JsonError: Error {
    case responseError
}

class Requests {
    static let go = Requests()
    
    private let baseUrl = "https://api.vk.com/method/"
    private var customUrl = ""
    private let apiVersion = "5.120"
    private let accessToken = Session.instance.token
    
    private init() {}
    
    // MARK: - пользователи
    
    func getMyFriends(handler: @escaping (Result<[UserRealm], Error>) -> Void) {
            customUrl = "friends.get"
            let fullUrl = baseUrl + customUrl
            let parameters: Parameters = [
                "access_token": accessToken,
                "v": apiVersion,
                "user_id": "\(Session.instance.userId)",
                "fields": "photo_100, nickname",
                "count": "50",
            ]
        
        AF.request(fullUrl,
                   method: .get,
                   parameters: parameters)
            .validate()
            .responseData(completionHandler: { responseData in
                guard let data = responseData.data else {
                    handler(.failure(JsonError.responseError))
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let requestResponse = try decoder.decode(UserRealmResponse.self, from: data)
                    RealmHelper.ask.saveObjects(requestResponse.response.items)
                    handler(.success(requestResponse.response.items))
                } catch {
                    handler(.failure(error))
                }
            })
        }
    
    func getUsersInfo(ids: String, completion: @escaping (_ users: [User]) -> ()) {
        customUrl = "users.get"
        let fullUrl = baseUrl + customUrl
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "user_ids": "\(ids)",
            "fields": "photo_400",
        ]
        
        AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            let json = JSON(response.value!)
            let users = json["response"].map { User(json: $0.1) }
            completion(users)
        }
    }
    
    func getUsersInfoRealm(ids: [Int], handler: @escaping (Result<[UserRealm], Error>) -> Void) {
        customUrl = "users.get"
        let fullUrl = baseUrl + customUrl
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "user_ids": "\(ids)",
            "fields": "photo_400",
        ]
        
        AF.request(fullUrl,
               method: .get,
               parameters: parameters)
        .validate()
        .responseData(completionHandler: { responseData in
            guard let data = responseData.data else {
                handler(.failure(JsonError.responseError))
                return
            }
            let decoder = JSONDecoder()
            do {
                let requestResponse = try decoder.decode(UserRealmResponse.self, from: data)
                RealmHelper.ask.saveObjects(requestResponse.response.items)
                handler(.success(requestResponse.response.items))
            } catch {
                handler(.failure(error))
            }
        })
    }
    
    
    
    // MARK: - фотографии
    
    func getAllPhotosByOwnerId (ownerId: Int, handler: @escaping (Result<[PhotoRealm], Error>) -> Void) {
        customUrl = "photos.getAll"
        let fullUrl = baseUrl + customUrl
        
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "count": "15",
            "owner_id": "\(ownerId)", //без owner_id приходят фото авторизованного пользователя
            "extended": "1",
        ]
        
        AF.request(fullUrl,
                   method: .get,
                   parameters: parameters)
                   .validate()
                   .responseData(completionHandler: { response in
            guard let json = try? JSON(response.data) else {
                    handler(.failure(JsonError.responseError))
                    return
                }
            let items = json["response"]["items"].arrayValue
            var photos = [PhotoRealm]()
            for item in items {
                let photo = PhotoRealm()
                photo.id = item["id"].intValue
                photo.ownerId = item["owner_id"].intValue
                photo.url = item["sizes"][3]["url"].stringValue
                photo.isLikedByMe = item["likes"]["user_likes"].boolValue
                photo.likesCount = item["likes"]["count"].intValue
                photos.append(photo)
        }
                    RealmHelper.ask.saveObjects(photos)
                    handler(.success(photos))
    })
    }
    
        // MARK: - группы

    func getMyGroups(handler: @escaping (Result<[GroupRealm], Error>) -> Void) {
        customUrl = "groups.get"
        let fullUrl = baseUrl + customUrl
        
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "owner_id": "\(Session.instance.userId)",
            "extended": "1",
        ]
        
        AF.request(fullUrl,
                   method: .get,
                   parameters: parameters)
            .validate()
            .responseData(completionHandler: { responseData in
                guard let data = responseData.data else {
                    handler(.failure(JsonError.responseError))
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let requestResponse = try decoder.decode(GroupRealmResponse.self, from: data)
                    RealmHelper.ask.saveObjects(requestResponse.response.items)
                    handler(.success(requestResponse.response.items))
                } catch {
                    handler(.failure(error))
                }
            })
        }

    func getGroupByQuery(handler: @escaping (Result<[GroupRealm], Error>) -> Void) {
        customUrl = "groups.search"
        let fullUrl = baseUrl + customUrl

        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "q": ""
        ]
        
        AF.request(fullUrl,
                   method: .get,
                   parameters: parameters)
            .validate()
            .responseData(completionHandler: { responseData in
                guard let data = responseData.data else {
                    handler(.failure(JsonError.responseError))
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let requestResponse = try decoder.decode(GroupRealmResponse.self, from: data)
                    RealmHelper.ask.saveObjects(requestResponse.response.items)
                    handler(.success(requestResponse.response.items))
                } catch {
                    handler(.failure(error))
                }
            })
    }
    
    func getGroupsCatalog(handler: @escaping (Result<[GroupRealm], Error>) -> Void) {
        customUrl = "groups.getCatalog"
        let fullUrl = baseUrl + customUrl
        
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "extended": "1"
        ]
        
        AF.request(fullUrl,
                   method: .get,
                   parameters: parameters)
            .validate()
            .responseData(completionHandler: { responseData in
                guard let data = responseData.data else {
                    handler(.failure(JsonError.responseError))
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let requestResponse = try decoder.decode(GroupRealmResponse.self, from: data)
                    RealmHelper.ask.saveObjects(requestResponse.response.items)
                    handler(.success(requestResponse.response.items))
                } catch {
                    handler(.failure(error))
                }
        })
    }
    
    func joinGroup(id: Int) {
        customUrl = "groups.join"
        let fullUrl = baseUrl + customUrl
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "group_id": "\(id)"
        ]
        
        AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            
        }
        print("succsessfull joined group \(id)")
    }
    
    func leaveGroup(id: Int) {
        customUrl = "groups.leave"
        let fullUrl = baseUrl + customUrl
        let parameters: Parameters = [
               "access_token": accessToken,
               "v": apiVersion,
               "group_id": "\(id)"
           ]
               
        AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
           
        }
         print("succsessfull left group \(id)")
    }
    
    // MARK: - лайки
    
    func addLike(_ itemId: Int, _ ownerId: Int) {
        customUrl = "likes.add"
        let fullUrl = baseUrl + customUrl
        let parameters: Parameters = [
                "access_token": accessToken,
                "v": apiVersion,
                "owner_id": "\(ownerId)",
                "item_id": "\(itemId)",
                "type": "photo",
               ]
        AF.request(fullUrl, method: .post, parameters: parameters, headers: nil).responseJSON { (response) in

        }
    }
    
    func deleteLike(_ itemId: Int, _ ownerId: Int) {
        customUrl = "likes.delete"
        let fullUrl = baseUrl + customUrl
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "owner_id": "\(ownerId)",
            "item_id": "\(itemId)",
            "type": "photo",
           ]
               
        AF.request(fullUrl, method: .post, parameters: parameters, headers: nil).responseJSON { (response) in

        }
    }
    
    // MARK: Новости
    
    func getNews(completion: @escaping (_ news: [FeedRecord], _ sourceDetails: [SourceDetails]) -> ()) {
        customUrl = "newsfeed.get"
        let fullUrl = baseUrl + customUrl
        
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "count": "50",
            "filters": "post, photo",
            "return_banned": "0",
            "max_photos": "1",
            "source_ids": "friends",
            "fields": "id, first_name, last_name, photo_400",
        ]
        
        DispatchQueue.global(qos: .utility).async {
            AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
                
                let json = JSON(response.value!)
                    
                    let news = json["response"]["items"].map { FeedRecord(json: $0.1)}
                    
                    var sourceDetails = [SourceDetails]()
                    
                    let profiles = json["response"]["profiles"].arrayValue
                    for item in profiles {
                        let profile = SourceDetails()
                        profile.id = item["id"].intValue
                        profile.name = item["first_name"].stringValue + " " + item["last_name"].stringValue
                        profile.avatar = item["photo_400"].stringValue
                        sourceDetails.append(profile)
                    }
                    let groups = json["response"]["groups"].arrayValue
                    for item in groups {
                        let group = SourceDetails()
                        group.id = item["id"].intValue
                        group.name = item["name"].stringValue
                        group.avatar = item["photo_400"].stringValue
                        sourceDetails.append(group)
                    }
                    completion(news, sourceDetails)
                }
        }
    }
}
