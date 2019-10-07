//
//  FeedViewTitleCellNode.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 08/10/2019.
//

import AsyncDisplayKit
import BonMot

final class FeedViewTitleCellNode: ASCellNode {

  // MARK: Constants

  private struct Typo {
    static let title = StringStyle([
      .font(.systemFont(ofSize: 48, weight: .bold)),
      .color(.oc_gray9),
    ])
  }


  // MARK: UI

  private let titleNode = ASTextNode()


  // MARK: Initializing

  override init() {
    super.init()
    self.automaticallyManagesSubnodes = true
    self.titleNode.attributedText = "Alone\nSocial\nClub".styled(with: Typo.title)
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: UIEdgeInsets(left: 20), child: ASWrapperLayoutSpec(layoutElement: self.titleNode))
  }
}
