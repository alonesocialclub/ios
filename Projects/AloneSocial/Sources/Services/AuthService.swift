//
//  AuthService.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import RxSwift

protocol AuthServiceProtocol {
  func join(name: String) -> Single<User>
}

final class AuthService: AuthServiceProtocol {
  private let networking: Networking
  private let authTokenStore: AuthTokenStore

  init(networking: Networking, authTokenStore: AuthTokenStore) {
    self.networking = networking
    self.authTokenStore = authTokenStore
  }

  func join(name: String) -> Single<User> {
    return self.networking.request(AuthAPI.join(name: name))
      .map(JoinResponse.self)
      .do(onSuccess: { [weak self] response in
        try self?.authTokenStore.save(response.authToken)
      })
      .map { $0.user }
  }
}

private struct JoinResponse: Decodable {
  let authToken: String
  let user: User
}
