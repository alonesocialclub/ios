//
//  PostAPI.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/11.
//

import MoyaSugar

enum PostAPI: BaseAPI {
  case create(pictureID: String, text: String)
}

extension PostAPI {
  var route: Route {
    switch self {
    case .create:
      return .post("/posts")
    }
  }

  var parameters: Parameters? {
    switch self {
    case let .create(pictureID, text):
      return JSONEncoding() => [
        "picture": [
          "id": pictureID
        ],
        "text": text
      ]
    }
  }
}
