//
//  RefreshControl.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 08/10/2019.
//

import UIKit

final class RefreshControl: UIRefreshControl {
  private static let swizzle: Void = {
    method_exchangeImplementations(
      class_getInstanceMethod(RefreshControl.self, NSSelectorFromString("_scrollViewHeight"))!,
      class_getInstanceMethod(RefreshControl.self, NSSelectorFromString("as_scrollViewHeight"))!
    )
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.zPosition = -999
  }

  override convenience init() {
    self.init(frame: .zero)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didMoveToSuperview() {
    RefreshControl.swizzle
    super.didMoveToSuperview()
    if let scrollView = self.superview as? UIScrollView {
      self.tintColor = self.tintColor ?? UIRefreshControl.appearance().tintColor
      scrollView.contentOffset.y = -self.bounds.height
    }
  }

  @objc func as_scrollViewHeight() -> CGFloat {
    return 0
  }
}
