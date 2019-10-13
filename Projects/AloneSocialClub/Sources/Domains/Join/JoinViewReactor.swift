//
//  JoinViewReactor.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import Pure
import ReactorKit
import RxSwift

final class JoinViewReactor: Reactor, FactoryModule {
  struct Dependency {
    let authService: AuthServiceProtocol
    let appleAuthService: AppleAuthServiceProtocol
  }

  enum Action {
    case join(name: String)
    case signInWithApple
  }

  enum Mutation {
    case setLoading(Bool)
    case setAuthenticated
    case setError(Error)
  }

  struct State {
    var isLoading: Bool = false
    var isAuthenticated: Bool = false
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

    case .signInWithApple:
      return Observable.concat([
        Observable.just(Mutation.setLoading(true)),
        self.signInWithApple(),
        Observable.just(Mutation.setLoading(false)),
      ])
    }
  }

  private func join(name: String) -> Observable<Mutation> {
    return self.dependency.authService.join(name: name)
      .map { _ in Mutation.setAuthenticated }
      .catchError { error in .just(Mutation.setError(error)) }
      .asObservable()
  }

  private func signInWithApple() -> Observable<Mutation> {
    let dependency = self.dependency
    let loginWithAppleCredential = self.loginWithAppleCredential
    let joinAndConnectAppleCredential = self.joinAndConnectAppleCredential

    return dependency.appleAuthService.authenticate()
      .flatMap { credential -> Single<Mutation> in
        loginWithAppleCredential(credential).catchError { error in
          guard error.httpStatusCode == 401 else { return .error(error) }
          return joinAndConnectAppleCredential(credential)
        }
      }
      .catchError { error in .just(Mutation.setError(error)) }
      .asObservable()
  }

  private func loginWithAppleCredential(_ credential: AppleIDCredential) -> Single<Mutation> {
    return dependency.authService.loginWithApple(userIdentifier: credential.userIdentifier, authorizationCode: credential.authorizationCode)
      .map { _ in Mutation.setAuthenticated }
  }

  private func joinAndConnectAppleCredential(_ credential: AppleIDCredential) -> Single<Mutation> {
    let dependency = self.dependency
    return dependency.authService.join(name: credential.displayName)
      .flatMap { _ in
        dependency.authService.connectAppleCredential(userIdentifier: credential.userIdentifier, authorizationCode: credential.authorizationCode)
      }
      .map { _ in Mutation.setAuthenticated }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case .setAuthenticated:
      newState.isAuthenticated = true

    case let .setError(error):
      newState.errorMessage = error.localizedDescription
    }
    return newState
  }
}
