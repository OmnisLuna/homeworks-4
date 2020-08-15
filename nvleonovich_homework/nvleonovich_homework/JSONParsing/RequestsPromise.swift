import SwiftyJSON
import Alamofire
import RealmSwift
import PromiseKit


class RequestsPromise {
    static let go = RequestsPromise()
    
    private let baseUrl = "https://api.vk.com/method/"
    private var customUrl = ""
    private let apiVersion = "5.120"
    private let accessToken = Session.instance.token
    
    private init() {}
    
    func getMyGroupsPromise() -> Promise<[GroupRealm]> {
        customUrl = "groups.get"
        let fullUrl = baseUrl + customUrl
        
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "owner_id": "\(Session.instance.userId)",
            "extended": "1",
        ]
        
        let promise = Promise<[GroupRealm]> { resolver in
            AF.request(fullUrl,
                       method: .get,
                       parameters: parameters)
                .validate()
                .responseData(completionHandler: { responseData in
                    guard let data = responseData.data else {
                        resolver.reject(JsonError.responseError)
                        return
                    }
                    let decoder = JSONDecoder()
                    do {
                        let requestResponse = try decoder.decode(GroupRealmResponse.self, from: data)
                        resolver.fulfill(requestResponse.response.items)
                    } catch {
                        resolver.reject(error)
                    }
                })
        }
        return promise
    }
}
