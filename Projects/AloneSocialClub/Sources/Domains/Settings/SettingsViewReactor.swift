//
//  SettingsViewReactor.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/28.
//

import Pure
import ReactorKit
import RxSwift

final class SettingsViewReactor: Reactor, FactoryModule {
  struct Dependency {
    let authService: AuthServiceProtocol
  }

  enum Action {
    case signOut
  }

  enum Mutation {
    case setSignedOut
  }

  struct State {
    var sections: [SettingsViewSection]
    var isSignedOut: Bool = false
  }

  private let dependency: Dependency
  let initialState: State

  init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.dependency = dependency
    self.initialState = State(sections: [
      SettingsViewSection(identity: .basic, items: [.signOut])
    ])
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .signOut:
      return self.dependency.authService.signOut().andThen(Observable.just(Mutation.setSignedOut))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setSignedOut:
      newState.isSignedOut = true
    }
    return newState
  }
}
