import AsyncDisplayKit

class FriendPhotosNode: ASCellNode {
    private let imageNode = ASNetworkImageNode()
    private let photo: PhotoRealm

    init(with photo: PhotoRealm) {
        self.photo = photo
        super.init()
        setupSubNodes()
    }
    
    private func setupSubNodes() {
        imageNode.url = URL(string: photo.url ?? "")!
        imageNode.contentMode = .scaleAspectFill
        addSubnode(imageNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var imageRatio: CGFloat = 0.5
        if imageNode.image != nil {
          imageRatio = (imageNode.image?.size.height)! / (imageNode.image?.size.width)!
        }
//
//        let imagePlace = ASRatioLayoutSpec(ratio: imageRatio, child: imageNode)
        
        let width = constrainedSize.max.width
        imageNode.style.preferredSize = CGSize(width: width, height: width*imageRatio)

//        let stackLayout = ASStackLayoutSpec.horizontal()
//        stackLayout.justifyContent = .start
//        stackLayout.alignItems = .start
//        stackLayout.style.flexShrink = 1.0
//        stackLayout.children = [imagePlace]

//        return ASInsetLayoutSpec(insets: UIEdgeInsets.zero, child: stackLayout)
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }
}
