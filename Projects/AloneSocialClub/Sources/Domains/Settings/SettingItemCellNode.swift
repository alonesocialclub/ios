//
//  SettingItemCellNode.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/28.
//

import AsyncDisplayKit
import BonMot

final class SettingItemCellNode: ASCellNode {

  // MARK: Constants

  private enum Typo {
    static let title = StringStyle([
      .font(.systemFont(ofSize: 24, weight: .bold)),
      .color(.oc_gray9),
    ])
  }


  // MARK: Properties

  override var isHighlighted: Bool {
    didSet {
      self.backgroundColor = self.isHighlighted ? .oc_gray2 : .white
    }
  }


  // MARK: UI

  private let titleNode = ASTextNode()


  // MARK: Initializing

  init(title: String) {
    super.init()
    self.automaticallyManagesSubnodes = true
    self.selectionStyle = .none
    self.backgroundColor = .white
    self.titleNode.attributedText = title.styled(with: Typo.title)
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(insets: UIEdgeInsets(horizontal: 15, vertical: 12), child: self.titleNode)
  }
}
