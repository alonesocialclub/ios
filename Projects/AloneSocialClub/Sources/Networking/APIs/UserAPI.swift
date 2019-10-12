//
//  UserAPI.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import MoyaSugar

enum UserAPI: BaseAPI {
  case me
}

extension UserAPI {
  var route: Route {
    switch self {
    case .me:
      return .get("/me")
    }
  }

  var parameters: Parameters? {
    switch self {
    default:
      return nil
    }
  }
}
