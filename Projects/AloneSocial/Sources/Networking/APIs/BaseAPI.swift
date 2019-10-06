//
//  BaseAPI.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import MoyaSugar

protocol BaseAPI: SugarTargetType {
}

extension BaseAPI {
  var baseURL: URL {
    return URL(string: "https://api.alone.social")!
  }

  var headers: [String: String]? {
    return nil
  }

  var sampleData: Data {
    return Data()
  }
}
