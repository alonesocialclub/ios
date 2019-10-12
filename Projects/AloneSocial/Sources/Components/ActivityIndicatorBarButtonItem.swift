//
//  ActivityIndicatorBarButtonItem.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import UIKit
import RxCocoa
import RxSwift

final class ActivityIndicatorBarButtonItem: UIBarButtonItem {
  private let activityIndicatorView: UIActivityIndicatorView

  var isAnimating: Bool {
    get { self.activityIndicatorView.isAnimating }
    set { newValue ? self.startAnimating() : self.stopAnimating() }
  }

  init(style: UIActivityIndicatorView.Style) {
    self.activityIndicatorView = UIActivityIndicatorView(style: style)
    super.init()
    self.customView = self.activityIndicatorView
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func startAnimating() {
    self.activityIndicatorView.startAnimating()
  }

  func stopAnimating() {
    self.activityIndicatorView.stopAnimating()
  }
}

extension Reactive where Base: ActivityIndicatorBarButtonItem {
  var isAnimating: Binder<Bool> {
    return Binder(self.base) { barButtonItem, isAnimating in
      barButtonItem.isAnimating = isAnimating
    }
  }
}
