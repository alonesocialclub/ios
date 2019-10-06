//
//  AuthPlugin.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import Moya

final class AuthPlugin: PluginType {
  private let authTokenStore: AuthTokenStore

  init(authTokenStore: AuthTokenStore) {
    self.authTokenStore = authTokenStore
  }

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    var request = request
    if let authToken = self.authTokenStore.authToken() {
      request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    }
    return request
  }
}
