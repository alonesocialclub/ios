//
//  PostEditorViewController.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 09/10/2019.
//

import UIKit

import AsyncDisplayKit
import BonMot
import Pure
import ReactorKit
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
      .font(.systemFont(ofSize: 18, weight: .regular)),
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
  }


  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { self.reactor = payload.reactor }
    super.init()

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


  // MARK: Binding

  func bind(reactor: PostEditorViewReactor) {
    self.bindTitle(reactor: reactor)
    self.bindSubmit(reactor: reactor)
    self.bindImageSelection(reactor: reactor)
    self.bindText(reactor: reactor)
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

  private func bindSubmit(reactor: PostEditorViewReactor) {
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
      .filterNil()
      .distinctUntilChanged()
      .map { Reactor.Action.setText($0.string) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let content = ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .stretch,
      children: [
        self.selectImageButtonLayout(),
        self.textInputNode.styled {
          $0.flexGrow = 1
        },
      ]
    )
    return ASInsetLayoutSpec(insets: self.node.safeAreaInsets, child: content)
  }

  private func selectImageButtonLayout() -> ASLayoutElement {
    return ASRatioLayoutSpec(ratio: 1, child: self.selectImageButtonNode)
  }
}
