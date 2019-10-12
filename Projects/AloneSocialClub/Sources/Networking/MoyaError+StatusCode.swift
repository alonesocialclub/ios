//
//  MoyaError+StatusCode.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/12.
//

import Alamofire
import Moya

extension Swift.Error {
  var httpStatusCode: Int? {
    return (self as? MoyaError)?.response?.statusCode
  }
}
