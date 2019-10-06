//
//  JoinViewReactor.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import Pure
import ReactorKit
import RxSwift

final class JoinViewReactor: Reactor, FactoryModule {
  struct Dependency {
    let authService: AuthServiceProtocol
  }

  enum Action {
    case join(name: String)
  }

  enum Mutation {
    case setLoading(Bool)
    case setJoined
    case setError(Error)
  }

  struct State {
    var isLoading: Bool = false
    var isJoined: Bool = false
    var errorMessage: String?
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
    case let .join(name):
      return Observable.concat([
        Observable.just(Mutation.setLoading(true)),
        self.join(name: name),
        Observable.just(Mutation.setLoading(false)),
      ])
    }
  }

  private func join(name: String) -> Observable<Mutation> {
    return self.dependency.authService.join(name: name)
      .map { _ in Mutation.setJoined }
      .catchError { error in .just(Mutation.setError(error)) }
      .asObservable()
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case .setJoined:
      newState.isJoined = true

    case let .setError(error):
      newState.errorMessage = error.localizedDescription
    }
    return newState
  }
}
