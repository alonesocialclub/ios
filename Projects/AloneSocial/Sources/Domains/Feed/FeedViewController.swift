//
//  FeedViewController.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import UIKit

import AsyncDisplayKit
import Pure
import ReactorKit
import RxDataSources_Texture
import RxSwift

final class FeedViewController: BaseViewController, View, FactoryModule {

  // MARK: Module

  struct Dependency {
    let reactorFactory: FeedViewReactor.Factory
    let postCellNodeFactory: PostCellNode.Factory
  }

  struct Payload {
    let reactor: FeedViewReactor
  }


  // MARK: Properties

  private let dependency: Dependency
  private lazy var dataSource = self.createDataSource()


  // MARK: UI

  private let refreshControl = RefreshControl()
  private let collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout()).then {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
  }


  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { self.reactor = payload.reactor }
    self.dependency = dependency
    super.init()
  }

  required convenience init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func createDataSource() -> RxASCollectionSectionedAnimatedDataSource<FeedViewSection> {
    let dependency = self.dependency
    return .init(
      animationConfiguration: AnimationConfiguration(animated: false),
      configureCellBlock: { dataSource, collectionNode, indexPath, sectionItem in
        switch sectionItem {
        case .title:
          return { FeedViewTitleCellNode() }

        case let .post(post):
          return { dependency.postCellNodeFactory.create(payload: .init(post: post)) }
        }
      }
    )
  }


  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionNode.view.refreshControl = self.refreshControl
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }


  // MARK: Binding

  func bind(reactor: FeedViewReactor) {
    self.bindRefreshing(reactor: reactor)
    self.bindDataSource(reactor: reactor)
    self.bindDelegate(reactor: reactor)
  }

  func bindRefreshing(reactor: FeedViewReactor) {
    self.rx.viewDidLoad
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.refreshControl.rx.controlEvent(.valueChanged)
      .map { Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.isRefreshing }
      .distinctUntilChanged()
      .filter { $0 == false }
      .bind(to: self.refreshControl.rx.isRefreshing)
      .disposed(by: self.disposeBag)
  }

  func bindDataSource(reactor: FeedViewReactor) {
    reactor.state.map { $0.sections }
      .distinctUntilChanged()
      .bind(to: self.collectionNode.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }

  func bindDelegate(reactor: FeedViewReactor) {
    self.collectionNode.rx.setDelegate(self)
      .disposed(by: self.disposeBag)
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASWrapperLayoutSpec(layoutElement: self.collectionNode)
  }
}

extension FeedViewController: ASCollectionDelegateFlowLayout, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(vertical: 20)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 30
  }
}
