import UIKit
import RealmSwift
import AsyncDisplayKit


class FriendsPhotoCollectionViewController: ASDKViewController<ASCollectionNode> {
    
    var currentUserId: Int = 0
    var photos = [PhotoRealm]()
    
    let collectionNode: ASCollectionNode
    
    override init() {
        collectionNode = ASCollectionNode(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        super.init(node: collectionNode)
        collectionNode.backgroundColor = .systemBackground
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionNode.backgroundColor = .systemBackground
        collectionNode.dataSource = self
        collectionNode.delegate = self
        requestPhotosForTest()
    }
    
//    override func viewWillLayoutSubviews() {
//        self.collectionNode.frame = self.view.bounds
//    }
//
    private func requestPhotosForTest() {
        Requests.go.getAllPhotosByOwnerId(ownerId: currentUserId) { [weak self] result in
            switch result {
            case .success(let photos):
                guard let self = self else { return }
                self.photos = photos
                self.collectionNode.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

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
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode,
                        nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let photo = photos[indexPath.row]
        
        let cellNodeBlock = { () -> ASCellNode in
            let node = FriendPhotosNode(with: photo)
            return node
        }
        return cellNodeBlock
    }
    
}
