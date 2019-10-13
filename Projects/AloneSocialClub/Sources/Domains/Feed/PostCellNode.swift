//
//  PostCellNode.swift
//  AloneSocialClub
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
      .font(.systemFont(ofSize: 16, weight: .regular)),
      .color(.oc_gray9),
    ])
    static let name = StringStyle([
      .font(.systemFont(ofSize: 16, weight: .semibold)),
      .color(.oc_gray9),
    ])
    static let date = StringStyle([
      .font(.systemFont(ofSize: 14, weight: .regular)),
      .color(.oc_gray5),
    ])
  }


  // MARK: UI

  private let imageNode = ASNetworkImageNode().then {
    $0.placeholderColor = .as_placeholder
    $0.placeholderFadeDuration = 0.3
  }
  private let textNode = ASTextNode().then {
    $0.maximumNumberOfLines = 2
    $0.truncationAttributedText = "...".styled(with: Typo.text)
  }
  private let avatarNode = ASNetworkImageNode().then {
    $0.placeholderColor = .as_placeholder
    $0.placeholderFadeDuration = 0.3
  }
  private let nameNode = ASTextNode().then {
    $0.maximumNumberOfLines = 1
  }
  private let dateNode = ASTextNode().then {
    $0.maximumNumberOfLines = 1
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
    self.imageNode.setImage(with: post.picture, size: .large)
    self.textNode.attributedText = post.text.styled(with: Typo.text)
    if let avatarPicture = post.author.profile.picture {
      self.avatarNode.setImage(with: avatarPicture, size: .small)
    } else {
      self.avatarNode.image = UIImage.emptyAvatar
    }
    self.nameNode.attributedText = post.author.profile.name.styled(with: Typo.name)
    self.dateNode.attributedText = post.createdAt.timeAgo.styled(with: Typo.date)


//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//    self.dateNode.attributedText = formatter.date(from: "2018-01-12T12:34:56+0900")!.timeAgo.styled(with: Typo.date)
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let content = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 15,
      justifyContent: .start,
      alignItems: .stretch,
      children: [
        self.imageLayout(),
        self.authorAndDateLayout(),
        self.textLayout(),
      ]
    )
    return ASInsetLayoutSpec(insets: UIEdgeInsets(bottom: 15), child: content)
  }

  private func imageLayout() -> ASLayoutElement {
    return ASRatioLayoutSpec(ratio: 1, child: self.imageNode)
  }

  private func authorAndDateLayout() -> ASLayoutElement {
    let content = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 15,
      justifyContent: .spaceBetween,
      alignItems: .center,
      children: [
        self.avatarAndNameLayout(),
        self.dateNode,
      ]
    )
    return ASInsetLayoutSpec(insets: UIEdgeInsets(horizontal: 15), child: content)
  }

  private func avatarAndNameLayout() -> ASLayoutElement {
    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 15,
      justifyContent: .start,
      alignItems: .center,
      children: [
        self.avatarNode.styled {
          $0.preferredSize.width = 30
          $0.preferredSize.height = 30
        },
        self.nameNode.styled {
          $0.flexShrink = 1
        },
      ]
    )
  }

  private func textLayout() -> ASLayoutElement {
    return ASInsetLayoutSpec(insets: UIEdgeInsets(horizontal: 15), child: self.textNode)
  }

  override func layoutDidFinish() {
    super.layoutDidFinish()
    self.avatarNode.cornerRadius = self.avatarNode.bounds.height / 2
  }
}
