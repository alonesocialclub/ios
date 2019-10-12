//
//  SceneSwitcherSpec.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import Nimble
import Quick
@testable import AloneSocialClub

final class SceneSwitcherSpecc: QuickSpec {
  override func spec() {
    var window: UIWindow!
    var sceneSwitcher: SceneSwitcher!

    beforeEach {
      window = UIWindow()
      sceneSwitcher = SceneSwitcher(window: window)
      sceneSwitcher.joinViewControllerFactory = .dummy()
      sceneSwitcher.feedViewControllerFactory = .dummy()
    }

    describe("switch(to:)") {
      context("when the scene is .join") {
        it("set the window's root view controller to join view controller") {
          sceneSwitcher.switch(to: .join)
          expect(window.rootViewController).to(beAKindOf(JoinViewController.self))
        }
      }

      context("when the scene is .main") {
        it("set the window's root view controller to feed view controller with navigation controller") {
          sceneSwitcher.switch(to: .main)
          expect(window.rootViewController).to(beAKindOf(UINavigationController.self))
          expect((window.rootViewController as? UINavigationController)?.viewControllers.first).to(beAKindOf(FeedViewController.self))
        }
      }
    }
  }
}
