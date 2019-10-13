//
//  MoyaError+Test.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/14.
//

import Moya

extension MoyaError {
  init(statusCode: Int) {
    let response = Response(statusCode: statusCode, data: Data())
    self = .statusCode(response)
  }
}
