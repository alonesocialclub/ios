//
//  NavigatorStub.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import Stubber
import URLNavigator
@testable import AloneSocialClub

final class NavigatorStub: NavigatorType {
  let matcher = URLMatcher()
  var delegate: NavigatorDelegate?

  func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
    // do nothing
  }

  func handle(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerFactory) {
    // do nothing
  }

  func viewController(for url: URLConvertible, context: Any?) -> UIViewController? {
    return UIViewController()
  }

  func handler(for url: URLConvertible, context: Any?) -> URLOpenHandler? {
    return { false }
  }

  @discardableResult
  func pushURL(_ url: URLConvertible, context: Any?, from: UINavigationControllerType?, animated: Bool) -> UIViewController? {
    return Stubber.invoke(pushURL, args: (url, context, from, animated), default: UIViewController())
  }

  @discardableResult
  func pushViewController(_ viewController: UIViewController, from: UINavigationControllerType?, animated: Bool) -> UIViewController? {
    return Stubber.invoke(pushViewController, args: (viewController, from, animated), default: UIViewController())
  }

  @discardableResult
  func presentURL(_ url: URLConvertible, context: Any?, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController? {
    return Stubber.invoke(presentURL, args: (url, context, wrap, from, animated, completion), default: UIViewController())
  }

  @discardableResult
  func presentViewController(_ viewController: UIViewController, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController? {
    return Stubber.invoke(presentViewController, args: (viewController, wrap, from, animated, completion), default: UIViewController())
  }

  @discardableResult
  func openURL(_ url: URLConvertible, context: Any?) -> Bool {
    return Stubber.invoke(openURL, args: (url, context), default: false)
  }
}
