//
//  PostCellNode.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import AsyncDisplayKit
import BonMot
import Pure
import ReactorKit
import RxSwift

final class PostCellNode: ASCellNode, FactoryModule {

  // MARK: Module

  struct Dependency {
  }

  struct Payload {
    let reactor: PostCellNodeReactor
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
    self.contentNode = PostContentNode(reactor: payload.reactor)
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


private final class PostContentNode: ASDisplayNode, View {

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
    static let pingButtonTitle = StringStyle([
      .font(.systemFont(ofSize: 14, weight: .semibold)),
      .color(.white),
    ])
  }


  // MARK: Properties

  var disposeBag = DisposeBag()


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
  private let pingButtonNode = ASButtonNode().then {
    $0.setAttributedTitle("Ping!".styled(with: Typo.pingButtonTitle), for: .normal)
    $0.setBackgroundImage(UIImage.resizable().corner(radius: 5).color(.oc_blue5).image, for: .normal)
    $0.setBackgroundImage(UIImage.resizable().corner(radius: 5).color(.oc_blue7).image, for: .highlighted)
    $0.hitTestSlop = UIEdgeInsets(all: -10)
  }


  // MARK: Initializing

  init(reactor: PostCellNodeReactor) {
    defer { self.reactor = reactor }
    super.init()
    self.automaticallyManagesSubnodes = true
    self.backgroundColor = .white
    self.cornerRadius = 15
    self.clipsToBounds = true
  }


  // MARK: Binding

  func bind(reactor: PostCellNodeReactor) {
    self.bindImage(reactor: reactor)
    self.bindText(reactor: reactor)
    self.bindAuthor(reactor: reactor)
    self.bindDate(reactor: reactor)
  }

  func bindImage(reactor: PostCellNodeReactor) {
    reactor.state.map { $0.post.picture }
      .distinctUntilChanged()
      .bind(to: self.imageNode.rx.image(size: .large))
      .disposed(by: self.disposeBag)
  }

  func bindText(reactor: PostCellNodeReactor) {
    reactor.state.map { $0.post.text }
      .distinctUntilChanged()
      .map { $0.styled(with: Typo.text) }
      .bind(to: self.textNode.rx.attributedText)
      .disposed(by: self.disposeBag)
  }

  func bindAuthor(reactor: PostCellNodeReactor) {
    reactor.state.map { $0.post.author.profile.picture }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] picture in
        guard let self = self else { return }
        if let picture = picture {
          self.avatarNode.setImage(with: picture, size: .small)
        } else {
          self.avatarNode.image = UIImage.emptyAvatar
        }
      })
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.post.author.profile.name }
      .distinctUntilChanged()
      .map { $0.styled(with: Typo.name) }
      .bind(to: self.nameNode.rx.attributedText)
      .disposed(by: self.disposeBag)
  }

  func bindDate(reactor: PostCellNodeReactor) {
    reactor.state.map { $0.post.createdAt }
      .distinctUntilChanged()
      .map { $0.timeAgo.styled(with: Typo.date) }
      .bind(to: self.dateNode.rx.attributedText)
      .disposed(by: self.disposeBag)
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
        self.pingButtonLayout(),
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

  private func pingButtonLayout() -> ASLayoutElement {
    return ASInsetLayoutSpec(insets: UIEdgeInsets(horizontal: 15), child: self.pingButtonNode.styled {
      $0.preferredSize.height = 30
    })
  }

  override func layoutDidFinish() {
    super.layoutDidFinish()
    self.avatarNode.cornerRadius = self.avatarNode.bounds.height / 2
  }
}
