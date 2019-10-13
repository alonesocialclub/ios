//
//  AuthAPI.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import MoyaSugar

enum AuthAPI: BaseAPI {
  case join(name: String)
  case loginWithApple(userIdentifier: String, authorizationCode: String)
  case connectAppleCredential(userIdentifier: String, authorizationCode: String)
}

extension AuthAPI {
  var route: Route {
    switch self {
    case .join:
      return .post("/anonymous/join")

    case .loginWithApple:
      return .post("/login/apple")

    case .connectAppleCredential:
      return .put("/me/credentials/apple")
    }
  }

  var parameters: Parameters? {
    switch self {
    case let .join(name):
      return JSONEncoding() => [
        "profile": [
          "name": name
        ]
      ]

    case let .loginWithApple(userIdentifier, authorizationCode):
      return JSONEncoding() => [
        "userIdentifier": userIdentifier,
        "authorizationCode": authorizationCode,
      ]

    case let .connectAppleCredential(userIdentifier, authorizationCode):
      return JSONEncoding() => [
        "userIdentifier": userIdentifier,
        "authorizationCode": authorizationCode,
      ]
    }
  }
}
