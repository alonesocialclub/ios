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
import RxSwift

final class FeedViewController: BaseViewController, View, FactoryModule {

  // MARK: Module

  struct Dependency {
    let reactorFactory: FeedViewReactor.Factory
  }

  struct Payload {
    let reactor: FeedViewReactor
  }


  // MARK: Properties

  private let dependency: Dependency


  // MARK: UI

  private let refreshControl = UIRefreshControl()
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


  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionNode.view.refreshControl = self.refreshControl
  }


  // MARK: Binding

  func bind(reactor: FeedViewReactor) {
    self.bindRefreshing(reactor: reactor)
    self.bindDataSource(reactor: reactor)
    self.bindDelegate(reactor: reactor)
  }

  func bindRefreshing(reactor: FeedViewReactor) {
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
  }

  func bindDelegate(reactor: FeedViewReactor) {
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASWrapperLayoutSpec(layoutElement: self.collectionNode)
  }
}
