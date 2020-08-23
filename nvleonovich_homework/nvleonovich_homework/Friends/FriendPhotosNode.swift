import AsyncDisplayKit

class FriendPhotosNode: ASCellNode {
    private let imageNode = ASNetworkImageNode()
    private let photo: Photo

    init(with photo: Photo) {
        self.photo = photo
        super.init()
        setupSubNodes()
    }
    
    private func setupSubNodes() {
        DispatchQueue.main.async {
            self.imageNode.url = URL(string: self.photo.sizes[3].url)!
            self.addSubnode(self.imageNode)
            }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width
        imageNode.style.preferredSize = CGSize(width: width, height: width*photo.sizes[3].aspectRatio)
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }
}
