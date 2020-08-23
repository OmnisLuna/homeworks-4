import UIKit
import RealmSwift
import AsyncDisplayKit


class FriendsPhotoCollectionViewController: ASDKViewController<ASCollectionNode> {
    
    var currentUserId: Int = 0
//    let animation = Animations()
    var photos = [PhotoRealm]()
//    var token: NotificationToken?
//    private var imageService: ImageService?
    
    let collectionNode: ASCollectionNode

    override init() {
        collectionNode = ASCollectionNode(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        super.init(node: collectionNode)
        collectionNode.backgroundColor = .systemBackground
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView.delegate = self
        requestPhotosForTest()
//        notificationsObserver()
//        imageService = ImageService(container: collectionView)
    }
    
    private func requestPhotosForTest() {
        Requests.go.getAllPhotosByOwnerId(ownerId: currentUserId) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.collectionNode.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //    p?rivate func notificationsObserver() {
//        guard let realm = try? Realm() else { return }
//        token = realm.objects(PhotoRealm.self).observe({ [weak self] (result) in
//            switch result {
//            case .initial:
//                print("Friend's photos data initialized")
//            case .update(_, deletions: _, insertions: _, modifications: _):
//                print("Friend's photos data changed")
//                self?.collectionView.reloadData()
//            case .error(let error):
//                fatalError(error.localizedDescription)
//            }
//        })
//    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return photos.count
//    }
    
    func collectionNode(_ collectionNode: ASCollectionNode,
    nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! FriendsPhotoCollectionViewCell
//
        let photo = photos[indexPath.row]
        
//        cell.likesCount.text = "\(photo.likesCount)"
//        cell.likesCount.textColor = cell.heartButton.isSelected ? #colorLiteral(red: 0.8094672561, green: 0, blue: 0.2113229036, alpha: 1)  : #colorLiteral(red: 0, green: 0.4539153576, blue: 1, alpha: 1)
//        cell.heartButton.isSelected = photo.isLikedByMe
        
//        cell.friendsPhoto.image = imageService?.photo(atIndexpath: indexPath, byUrl: photo.url ?? "placeholder-1-300x200.png")
        
        //замыкание для тапа на ячейку
//        cell.heartButtoonTap = { [weak self] in
//            let row = indexPath.row
//            self!.photos[row].isLikedByMe = !self!.photos[row].isLikedByMe
//            if self!.photos[row].isLikedByMe {
//                self!.photos[row].likesCount += 1
//            } else {
//                self!.photos[row].likesCount -= 1
//            }
//            self!.collectionView.reloadItems(at: [indexPath])
//            self!.animation.increaseElementOnTap(cell.heartButton)
//        }
        return {
            return FriendPhotosNode(with: photo)
        }
    }
    
    @IBAction func openPhotoinGallery(_ sender: Any) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openFullSizePhoto"
        {
            let target = segue.destination as! SwipePhotoController
            target.currentUserId = currentUserId
            let index = collectionNode.indexPathsForSelectedItems!.first!
            let photoIndex = index.item
            target.photoIndex = photoIndex
            target.photos = photos
        }
    }
    
}

//extension FriendsPhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let cellWidth = (view.bounds.width - 15) / 2
//
//        return CGSize(width: cellWidth, height: cellWidth)
//    }
//}


extension FriendsPhotoCollectionViewController: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode,
                        constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        
        let cellWidth = (view.bounds.width - 15) / 2
        let size = CGSize(width: cellWidth,
                          height: cellWidth)
        let range = ASSizeRange(min: size,
                                max: size)
        return range
    }
}

extension FriendsPhotoCollectionViewController: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
}
