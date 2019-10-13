//
//  PostEditorViewController.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 09/10/2019.
//

import UIKit

import AsyncDisplayKit
import BonMot
import Pure
import ReactorKit
import RxKeyboard
import RxSwift
import URLNavigator
import YPImagePicker

final class PostEditorViewController: BaseViewController, View, FactoryModule {

  // MARK: Module

  struct Dependency {
    let reactorFactory: PostEditorViewReactor.Factory
  }

  struct Payload {
    let reactor: PostEditorViewReactor
  }


  // MARK: Constants

  private enum Typo {
    static let selectImageButtonTitle = StringStyle([
      .font(.systemFont(ofSize: 24, weight: .bold)),
      .color(.oc_gray6),
    ])
    static let text = StringStyle([
      .font(.systemFont(ofSize: 16, weight: .regular)),
      .color(.oc_gray9),
    ])
    static let textPlaceholder = text.byAdding([
      .color(.as_textPlaceholder),
    ])
  }


  // MARK: Properties


  // MARK: UI

  private let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
  private let submitButtonItem = UIBarButtonItem(title: "Post", style: .done, target: nil, action: nil)
  private let activityIndicatorButtonItem = ActivityIndicatorBarButtonItem(style: .gray)

  private let scrollNode = ASScrollNode().then {
    $0.automaticallyManagesSubnodes = true
    $0.automaticallyManagesContentSize = true
  }
  private let selectImageButtonNode = ASButtonNode().then {
    $0.imageNode.contentMode = .scaleAspectFill
    $0.setAttributedTitle("Pick an image...".styled(with: Typo.selectImageButtonTitle), for: .normal)
    $0.setAttributedTitle(NSAttributedString(), for: .selected)
    $0.setBackgroundImage(UIImage.resizable().color(.oc_gray2).image, for: .normal)
    $0.setBackgroundImage(UIImage.resizable().color(.oc_gray3).image, for: .highlighted)
  }
  private let textInputNode = ASEditableTextNode().then {
    $0.typingAttributes = Typo.text.rawAttributes
    $0.attributedPlaceholderText = "Tell people where you at and what you're gonna do today.".styled(with: Typo.textPlaceholder)
    $0.textContainerInset = UIEdgeInsets(all: 15)
    $0.scrollEnabled = false
  }


  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { self.reactor = payload.reactor }
    super.init()

    self.scrollNode.layoutSpecBlock = { [weak self] node, constrainedSize in
      return self?.scrollNodeLayoutSpecThatFits(constrainedSize) ?? ASLayoutSpec()
    }

    self.preventFromModalGestureDismissal()
    self.configureNavigationItem()
  }

  required convenience init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func preventFromModalGestureDismissal() {
    if #available(iOS 13, *) {
      self.isModalInPresentation = true
    }
  }

  private func configureNavigationItem() {
    self.navigationItem.leftBarButtonItem = self.cancelButtonItem
    self.navigationItem.rightBarButtonItem = self.submitButtonItem
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.scrollNode.view.keyboardDismissMode = .interactive
  }


  // MARK: Binding

  func bind(reactor: PostEditorViewReactor) {
    self.bindTitle(reactor: reactor)
    self.bindCancel(reactor: reactor)
    self.bindSubmit(reactor: reactor)
    self.bindLoading(reactor: reactor)
    self.bindImageSelection(reactor: reactor)
    self.bindText(reactor: reactor)
    self.bindScroll()
  }

  private func bindTitle(reactor: PostEditorViewReactor) {
    reactor.state.map { $0.mode }
      .distinctUntilChanged()
      .map { mode in
        switch mode {
        case .new: return "New Post"
        }
      }
      .bind(to: self.rx.title)
      .disposed(by: self.disposeBag)
  }

  private func bindCancel(reactor: PostEditorViewReactor) {
    self.cancelButtonItem.rx.tap
      .subscribe(onNext: { [weak self] in
        // TODO: confirm if edited
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)
  }

  private func bindSubmit(reactor: PostEditorViewReactor) {
    reactor.state.map { $0.canSubmit }
      .distinctUntilChanged()
      .bind(to: self.submitButtonItem.rx.isEnabled)
      .disposed(by: self.disposeBag)

    self.submitButtonItem.rx.tap
      .map { Reactor.Action.submit }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.isSubmitted }
      .distinctUntilChanged()
      .filter { $0 == true }
      .subscribe(onNext: { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)
  }

  private func bindLoading(reactor: PostEditorViewReactor) {
    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] isLoading in
        guard let self = self else { return }
        self.navigationItem.rightBarButtonItem = isLoading ? self.activityIndicatorButtonItem : self.submitButtonItem
        self.activityIndicatorButtonItem.isAnimating = isLoading
        self.setControlNodesEnabled(!isLoading)
      })
      .disposed(by: self.disposeBag)
  }

  private func setControlNodesEnabled(_ isEnabled: Bool) {
    let allControlNodes: [ASDisplayNode] = [self.selectImageButtonNode, self.textInputNode]
    for node in allControlNodes {
      if let controlNode = node as? ASControlNode {
        controlNode.isEnabled = isEnabled
      } else {
        node.isUserInteractionEnabled = isEnabled
      }
      node.alpha = isEnabled ? 1 : 0.5
    }
  }

  private func bindImageSelection(reactor: PostEditorViewReactor) {
    reactor.state.map { $0.image }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] image in
        self?.selectImageButtonNode.setBackgroundImage(image, for: .selected)
        self?.selectImageButtonNode.setBackgroundImage(image, for: [.selected, .highlighted])
      })
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.image != nil }
      .distinctUntilChanged()
      .bind(to: self.selectImageButtonNode.rx.isSelected)
      .disposed(by: self.disposeBag)

    self.selectImageButtonNode.rx.tap
      .flatMap { [weak self] in self?.presentImagePicker() ?? .empty() }
      .map(Reactor.Action.setImage)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }

  private func presentImagePicker() -> Observable<UIImage> {
    let source = Observable<UIImage>.create { [weak self] observer in
      guard let self = self else {
        observer.onCompleted()
        return Disposables.create()
      }

      var config = YPImagePickerConfiguration()
      config.showsPhotoFilters = false
      config.library.mediaType = .photo
      config.library.onlySquare = true
      config.icons.capturePhotoImage = config.icons.capturePhotoImage.with(color: .oc_gray4)

      let pickerController = YPImagePicker(configuration: config)
      pickerController.didFinishPicking { [weak self] items, isCancelled in
        if let image = self?.firstImage(from: items), !isCancelled {
          observer.onNext(image)
        }
        pickerController.dismiss(animated: true, completion: observer.onCompleted)
      }
      self.present(pickerController, animated: true, completion: nil)

      return Disposables.create()
    }
    return source.observeOn(MainScheduler.instance)
  }

  private func firstImage(from items: [YPMediaItem]) -> UIImage? {
    return items.lazy.compactMap { item -> UIImage? in
      if case let .photo(photo) = item {
        return photo.image
      } else {
        return nil
      }
    }.first
  }

  private func bindText(reactor: PostEditorViewReactor) {
    reactor.state.map { $0.text }
      .distinctUntilChanged()
      .bind(to: self.textInputNode.rx.text(Typo.text.attributes))
      .disposed(by: self.disposeBag)

    self.textInputNode.rx.attributedText
      .map { $0?.string ?? "" }
      .distinctUntilChanged()
      .map(Reactor.Action.setText)
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }

  private func bindScroll() {
    self.textInputNode.rx.attributedText
      .subscribe(onNext: { [weak self] _ in
        self?.scrollToTextNodeCaret()
      })
      .disposed(by: self.disposeBag)

    RxKeyboard.instance.visibleHeight
      .drive(onNext: { [weak self] visibleHeight in
        self?.adjustScrollViewBottomInset(visibleKeyboardHeight: visibleHeight)
      })
      .disposed(by: self.disposeBag)
  }

  private func scrollToTextNodeCaret() {
    guard self.textInputNode.isNodeLoaded else { return }

    guard let selectedTextRange = self.textInputNode.textView.selectedTextRange else { return }
    let caretRect = self.textInputNode.textView.caretRect(for: selectedTextRange.start)
    let rect = self.scrollNode.view.convert(caretRect, from: self.textInputNode.textView)
    self.scrollNode.view.scrollRectToVisible(rect, animated: true)
  }

  private func adjustScrollViewBottomInset(visibleKeyboardHeight: CGFloat) {
    guard self.node.isNodeLoaded else { return }

    let bottomInset = max(0, visibleKeyboardHeight - self.node.safeAreaInsets.bottom)
    self.scrollNode.view.contentInset.bottom = bottomInset
    self.scrollNode.view.scrollIndicatorInsets.bottom = bottomInset

    self.scrollToTextNodeCaret()
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASWrapperLayoutSpec(layoutElement: self.scrollNode)
  }

  private func scrollNodeLayoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .stretch,
      children: [
        self.selectImageButtonLayout(),
        self.textInputNode.styled {
          $0.minHeight = ASDimensionMake(200)
        },
      ]
    )
  }

  private func selectImageButtonLayout() -> ASLayoutElement {
    return ASRatioLayoutSpec(ratio: 1, child: self.selectImageButtonNode)
  }
}
