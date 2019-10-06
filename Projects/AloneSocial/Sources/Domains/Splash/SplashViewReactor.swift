//
//  SplashViewReactor.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import Pure
import ReactorKit
import RxSwift

final class SplashViewReactor: Reactor, FactoryModule, Hashable {
  struct Dependency {
    let userService: UserServiceProtocol
  }

  enum Action {
    case authenticate
  }

  enum Mutation {
    case setLoading(Bool)
    case setAuthenticated(Bool)
  }

  struct State: Hashable {
    var isLoading: Bool = false
    var isAuthenticated: Bool?
  }

  private let dependency: Dependency
  let initialState: State

  init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.dependency = dependency
    self.initialState = State()
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .authenticate:
      return Observable.concat([
        Observable.just(Mutation.setLoading(true)),
        self.fetchAuthenticated(),
        Observable.just(Mutation.setLoading(true)),
      ])
    }
  }

  private func fetchAuthenticated() -> Observable<Mutation> {
    return self.dependency.userService.me()
    .map { _ in Mutation.setAuthenticated(true) }
    .catchErrorJustReturn(Mutation.setAuthenticated(false))
    .asObservable()
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case let .setAuthenticated(isAuthenticated):
      newState.isAuthenticated = isAuthenticated
    }
    return newState
  }
}
