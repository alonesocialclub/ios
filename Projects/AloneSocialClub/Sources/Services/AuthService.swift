//
//  AuthService.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import RxSwift
import AuthenticationServices

protocol AuthServiceProtocol {
  func join(name: String) -> Single<User>
  func loginWithApple(userIdentifier: String, authorizationCode: String) -> Single<User>
  func connectAppleCredential(userIdentifier: String, authorizationCode: String) -> Single<Void>
}

final class AuthService: AuthServiceProtocol {
  private let networking: NetworkingProtocol
  private let authTokenStore: AuthTokenStore

  init(networking: NetworkingProtocol, authTokenStore: AuthTokenStore) {
    self.networking = networking
    self.authTokenStore = authTokenStore
  }

  func join(name: String) -> Single<User> {
    return self.networking.request(AuthAPI.join(name: name))
      .map(AuthResponse.self)
      .do(onSuccess: { [weak self] response in
        try self?.authTokenStore.save(response.authToken)
      })
      .map { $0.user }
  }

  func loginWithApple(userIdentifier: String, authorizationCode: String) -> Single<User> {
    return self.networking.request(AuthAPI.loginWithApple(userIdentifier: userIdentifier, authorizationCode: authorizationCode))
      .map(AuthResponse.self)
      .do(onSuccess: { [weak self] response in
        try self?.authTokenStore.save(response.authToken)
      })
      .map { $0.user }
  }

  func connectAppleCredential(userIdentifier: String, authorizationCode: String) -> Single<Void> {
    return self.networking.request(AuthAPI.connectAppleCredential(userIdentifier: userIdentifier, authorizationCode: authorizationCode))
      .map { _ in }
  }
}

private struct AuthResponse: Decodable {
  let authToken: String
  let user: User
}
