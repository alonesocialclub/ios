//
//  FeedViewTitleCellNode.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 08/10/2019.
//

import AsyncDisplayKit
import BonMot
import Pure
import URLNavigator

final class FeedViewTitleCellNode: ASCellNode, FactoryModule {

  // MARK: Module

  struct Dependency {
    let postEditorViewControllerFactory: PostEditorViewController.Factory
    let navigator: NavigatorType
  }


  // MARK: Constants

  private struct Metric {
    static let uploadButtonSize = 35.f
  }

  private struct Typo {
    static let title = StringStyle([
      .font(.systemFont(ofSize: 48, weight: .bold)),
      .color(.oc_gray9),
    ])
  }


  // MARK: Properties

  private let dependency: Dependency


  // MARK: UI

  private let titleNode = ASTextNode().then {
    $0.attributedText = "Alone\nSocial\nClub".styled(with: Typo.title)
  }
  private let uploadButtonNode = ASButtonNode().then {
    $0.setImage(Image.uploadButtonForegroundImage(), for: .normal)
    $0.setBackgroundImage(Image.uploadButtonBackgroundImage(color: .oc_blue5), for: .normal)
    $0.setBackgroundImage(Image.uploadButtonBackgroundImage(color: .oc_blue7), for: .highlighted)
  }

  private enum Image {
    static func uploadButtonForegroundImage() -> UIImage {
      let length = Metric.uploadButtonSize - 15
      return UIImage.with(size: CGSize(width: length, height: length)) { context in
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(2)
        context.addLines(between: [
          CGPoint(x: length / 2, y: 0),
          CGPoint(x: length / 2, y: length),
        ])
        context.addLines(between: [
          CGPoint(x: 0, y: length / 2),
          CGPoint(x: length, y: length / 2),
        ])
        context.drawPath(using: .stroke)
      }
    }

    static func uploadButtonBackgroundImage(color: UIColor) -> UIImage {
      let size = CGSize(width: Metric.uploadButtonSize, height: Metric.uploadButtonSize)
      return UIImage.size(size)
        .corner(radius: Metric.uploadButtonSize / 2)
        .color(color)
        .image
    }
  }


  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    self.dependency = dependency
    super.init()
    self.automaticallyManagesSubnodes = true
    self.uploadButtonNode.addTarget(self, action: #selector(uploadButtonNodeDidTap), forControlEvents: .touchUpInside)
  }

  @objc private func uploadButtonNodeDidTap() {
    let reactor = self.dependency.postEditorViewControllerFactory.dependency.reactorFactory.create(payload: .init(
      mode: .new
    ))
    let viewController = self.dependency.postEditorViewControllerFactory.create(payload: .init(reactor: reactor))
    self.dependency.navigator.present(viewController, wrap: UINavigationController.self)
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let content = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 0,
      justifyContent: .spaceBetween,
      alignItems: .start,
      children: [
        self.titleNode,
        self.uploadButtonLayout(),
      ]
    ).styled {
      $0.preferredLayoutSize.width = ASDimensionMake("100%")
    }
    return ASInsetLayoutSpec(insets: UIEdgeInsets(left: 20, right: 20), child: content)
  }

  private func uploadButtonLayout() -> ASLayoutElement {
    return ASInsetLayoutSpec(
      insets: UIEdgeInsets(top: 10),
      child: self.uploadButtonNode.styled {
        $0.preferredSize.width = Metric.uploadButtonSize
        $0.preferredSize.height = Metric.uploadButtonSize
      }
    )
  }
}
