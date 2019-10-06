//
//  ActivityIndicatorNode.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import AsyncDisplayKit
import RxCocoa
import RxSwift

final class ActivityIndicatorNode: ASDisplayNode {
  private var indicatorView: UIActivityIndicatorView? {
    return self.view as? UIActivityIndicatorView
  }

  init(style: UIActivityIndicatorView.Style) {
    super.init()
    self.setViewBlock { UIActivityIndicatorView(style: style) }
    self.isUserInteractionEnabled = false
  }

  func startAnimating() {
    ASPerformBlockOnMainThread {
      self.indicatorView?.startAnimating()
    }
  }

  func stopAnimating() {
    ASPerformBlockOnMainThread {
      self.indicatorView?.stopAnimating()
    }
  }
}

extension Reactive where Base: ActivityIndicatorNode {
  var isAnimating: Binder<Bool> {
    return Binder(self.base) { node, isAnimating in
      if isAnimating {
        node.startAnimating()
      } else {
        node.stopAnimating()
      }
    }
  }
}
