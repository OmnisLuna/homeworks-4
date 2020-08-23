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
            self.imageNode.contentMode = .scaleAspectFill
            self.addSubnode(self.imageNode)
            }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var imageRatio: CGFloat = 0.5
        if imageNode.image != nil {
          imageRatio = (imageNode.image?.size.height)! / (imageNode.image?.size.width)!
        }
        let imagePlace = ASRatioLayoutSpec(ratio: imageRatio, child: imageNode)
        let stackLayout = ASStackLayoutSpec.horizontal()
        stackLayout.justifyContent = .start
        stackLayout.alignItems = .start
        stackLayout.style.flexShrink = 1.0
        stackLayout.children = [imagePlace]
        return ASInsetLayoutSpec(insets: UIEdgeInsets.zero, child: stackLayout)
    }
}
