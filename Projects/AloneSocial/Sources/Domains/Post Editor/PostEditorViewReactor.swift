//
//  PostEditorViewReactor.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 09/10/2019.
//

import Pure
import ReactorKit
import RxSwift

final class PostEditorViewReactor: Reactor, FactoryModule {
  struct Dependency {
  }

  enum Action {
  }

  enum Mutation {
  }

  struct State {
  }

  let initialState: State

  init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.initialState = State()
  }
}
