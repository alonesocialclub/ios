//
//  AuthAPI.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import MoyaSugar

enum AuthAPI: BaseAPI {
  case join(name: String)
}

extension AuthAPI {
  var route: Route {
    switch self {
    case .join:
      return .get("/v1/auth/join")
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
    }
  }
}
