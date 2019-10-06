//
//  AppDelegate.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//  Copyright © 2019 Alone Social. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

  private let dependency: AppDependency

  private override init() {
    self.dependency = AppDependency.resolve()
    super.init()
  }

  init(dependency: AppDependency) {
    self.dependency = dependency
  }

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.rootViewController = self.createSplashViewController()
    window.makeKeyAndVisible()
    self.window = window
    return true
  }

  private func createSplashViewController() -> SplashViewController {
    let reactor = self.dependency.splashViewControllerFactory.dependency.reactorFactory.create()
    return self.dependency.splashViewControllerFactory.create(payload: .init(reactor: reactor))
  }
}
