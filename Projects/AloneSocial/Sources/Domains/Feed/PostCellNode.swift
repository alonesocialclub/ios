//
//  PostCellNode.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import AsyncDisplayKit
import BonMot
import Pure

final class PostCellNode: ASCellNode, FactoryModule {

  // MARK: Module

  struct Dependency {
  }

  struct Payload {
    let post: Post
  }


  // MARK: Properties

  private let dependency: Dependency
  private let payload: Payload


  // MARK: UI

  private let contentNode: PostContentNode
  private let shadowNode = ASDisplayNode().then {
    $0.backgroundColor = .white
    $0.shadowColor = UIColor.oc_gray9.cgColor
    $0.shadowOpacity = 0.15
    $0.shadowOffset = CGSize(width: 0, height: 10)
    $0.shadowRadius = 20
    $0.clipsToBounds = false
  }


  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    self.dependency = dependency
    self.payload = payload
    self.contentNode = PostContentNode(post: payload.post)
    self.shadowNode.cornerRadius = self.contentNode.cornerRadius
    super.init()
    self.automaticallyManagesSubnodes = true
    self.clipsToBounds = false
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let card = ASBackgroundLayoutSpec(child: self.contentNode, background: self.shadowNode)
    return ASInsetLayoutSpec(insets: UIEdgeInsets(horizontal: 20), child: card)
  }
}


private final class PostContentNode: ASDisplayNode {

  // MARK: Constants

  private enum Typo {
    static let text = StringStyle([
      .font(.systemFont(ofSize: 18, weight: .bold)),
      .color(.oc_gray9),
      .baselineOffset(1),
    ])
  }


  // MARK: UI

  private let imageNode = ASNetworkImageNode().then {
    $0.placeholderColor = .as_placeholder
    $0.placeholderFadeDuration = 0.3
  }
  private let avatarNode = ASNetworkImageNode().then {
    $0.placeholderColor = .as_placeholder
    $0.placeholderFadeDuration = 0.3
  }
  private let textNode = ASTextNode().then {
    $0.maximumNumberOfLines = 2
  }


  // MARK: Initializing

  init(post: Post) {
    super.init()
    self.automaticallyManagesSubnodes = true
    self.backgroundColor = .white
    self.cornerRadius = 15
    self.clipsToBounds = true
    self.configure(post: post)
  }

  private func configure(post: Post) {
    self.imageNode.url = URL(string: "https://alone.social/img/IMG_1525.png")
    self.avatarNode.url = URL(string: "https://alone.social/img/profile/sy.jpg")
    self.textNode.attributedText = post.text.styled(with: Typo.text)
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 15,
      justifyContent: .start,
      alignItems: .stretch,
      children: [
        self.imageLayout(),
        self.avatarAndTextLayout()
      ]
    )
  }

  private func imageLayout() -> ASLayoutElement {
    return ASRatioLayoutSpec(ratio: 1, child: self.imageNode)
  }

  private func avatarAndTextLayout() -> ASLayoutElement {
    let content = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 15,
      justifyContent: .start,
      alignItems: .center,
      children: [
        self.avatarNode.styled {
          $0.preferredSize.width = 45
          $0.preferredSize.height = 45
        },
        self.textNode,
      ]
    )
    return ASInsetLayoutSpec(insets: UIEdgeInsets(left: 15, bottom: 15, right: 30), child: content)
  }

  override func layoutDidFinish() {
    super.layoutDidFinish()
    self.avatarNode.cornerRadius = self.avatarNode.bounds.height / 2
  }
}
