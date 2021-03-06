//
//  SceneSwitcher.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import UIKit

final class SceneSwitcher {
  enum Scene {
    case join
    case main
  }

  private let window: UIWindow
  var joinViewControllerFactory: JoinViewController.Factory?
  var feedViewControllerFactory: FeedViewController.Factory?

  init(window: UIWindow) {
    self.window = window
  }

  func `switch`(to scene: Scene) {
    switch scene {
    case .join:
      guard let factory = self.joinViewControllerFactory else { preconditionFailure() }
      let reactor = factory.dependency.reactorFactory.create()
      let viewController = factory.create(payload: .init(reactor: reactor))
      self.window.rootViewController = viewController

    case .main:
      guard let factory = self.feedViewControllerFactory else { preconditionFailure() }
      let reactor = factory.dependency.reactorFactory.create()
      let viewController = factory.create(payload: .init(reactor: reactor))
      self.window.rootViewController = UINavigationController(rootViewController: viewController)
    }
  }
}
