//
//  SplashViewController.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import AsyncDisplayKit
import UIKit

import Pure
import ReactorKit
import RxSwift

final class SplashViewController: BaseViewController, View, FactoryModule {

  // MARK: Module

  struct Dependency {
    let reactorFactory: SplashViewReactor.Factory
  }

  struct Payload {
    let reactor: SplashViewReactor
  }


  // MARK: UI

  private let activityIndicatorNode = ActivityIndicatorNode(style: .gray)


  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { self.reactor = payload.reactor }
    super.init()
  }

  required convenience init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }


  // MARK: Binding

  func bind(reactor: SplashViewReactor) {
    self.bindLoading(reactor: reactor)
    self.bindNavigation(reactor: reactor)
  }

  private func bindLoading(reactor: SplashViewReactor) {
    self.rx.viewDidLoad
      .map { Reactor.Action.authenticate }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .bind(to: self.activityIndicatorNode.rx.isAnimating)
      .disposed(by: self.disposeBag)
  }

  private func bindNavigation(reactor: SplashViewReactor) {

  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: self.activityIndicatorNode)
  }
}
