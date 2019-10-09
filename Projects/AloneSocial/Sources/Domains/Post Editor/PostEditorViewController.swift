//
//  PostEditorViewController.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 09/10/2019.
//

import UIKit

import Pure
import ReactorKit
import RxSwift
import URLNavigator

final class PostEditorViewController: BaseViewController, View, FactoryModule {

  // MARK: Module

  struct Dependency {
    let reactorFactory: PostEditorViewReactor.Factory
  }

  struct Payload {
    let reactor: PostEditorViewReactor
  }


  // MARK: Properties


  // MARK: UI


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
    self.view.backgroundColor = .white
  }


  // MARK: Binding

  func bind(reactor: PostEditorViewReactor) {
  }
}
