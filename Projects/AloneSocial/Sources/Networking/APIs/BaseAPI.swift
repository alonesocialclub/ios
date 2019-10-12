//
//  BaseAPI.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import MoyaSugar

protocol BaseAPI: SugarTargetType, Hashable {
}

extension BaseAPI {
  var baseURL: URL {
    return URL(string: "http://52.78.145.107")!
  }

  var headers: [String: String]? {
    return nil
  }

  var sampleData: Data {
    return Data()
  }
}
