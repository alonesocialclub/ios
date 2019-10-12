//
//  PictureAPI.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 2019/10/12.
//

import MoyaSugar

enum PictureAPI: BaseAPI {
  case upload(UIImage)
}

extension PictureAPI {
  var route: Route {
    switch self {
    case .upload:
      return .post("/pictures")
    }
  }

  var parameters: Parameters? {
    switch self {
    default:
      return nil
    }
  }

  var task: Task {
    switch self {
    case let .upload(image):
      return Task.uploadMultipart(["file": image].asMultipartFormData())
    }
  }
}
