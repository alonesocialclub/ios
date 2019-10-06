//
//  FeedAPI.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import MoyaSugar

enum FeedAPI: BaseAPI {
  case feed
}

extension FeedAPI {
  var route: Route {
    switch self {
    case .feed:
      return .get("/feed")
    }
  }

  var parameters: Parameters? {
    switch self {
    default:
      return nil
    }
  }
}
