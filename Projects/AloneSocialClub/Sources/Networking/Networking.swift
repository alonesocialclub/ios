//
//  Networking.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import MoyaSugar
import RxSwift

protocol NetworkingProtocol {
  func request(_ target: SugarTargetType, file: StaticString, function: StaticString, line: UInt) -> Single<Response>
}

extension NetworkingProtocol {
  func request(_ target: SugarTargetType, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Single<Response> {
    return self.request(target, file: file, function: function, line: line)
  }
}

final class Networking: MoyaSugarProvider<MultiSugarTarget>, NetworkingProtocol {
  init(authPlugin: AuthPlugin) {
    let session = MoyaProvider<MultiSugarTarget>.defaultAlamofireSession()
    session.sessionConfiguration.timeoutIntervalForRequest = 10

    super.init(session: session, plugins: [authPlugin])
  }

  func request(_ target: SugarTargetType, file: StaticString, function: StaticString, line: UInt) -> Single<Response> {
    let requestString = "\(target.method.rawValue) \(target.path)"
    return self.rx.request(.target(target))
      .filterSuccessfulStatusCodes()
      .do(
        onSuccess: { value in
          let message = "SUCCESS: \(requestString) (\(value.statusCode))"
          log.debug(message, file: file, function: function, line: line)
        },
        onError: { error in
          if let response = (error as? MoyaError)?.response {
            if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
              let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
              log.warning(message, file: file, function: function, line: line)
            } else if let rawString = String(data: response.data, encoding: .utf8) {
              let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
              log.warning(message, file: file, function: function, line: line)
            } else {
              let message = "FAILURE: \(requestString) (\(response.statusCode))"
              log.warning(message, file: file, function: function, line: line)
            }
          } else {
            let message = "FAILURE: \(requestString)\n\(error)"
            log.warning(message, file: file, function: function, line: line)
          }
        },
        onSubscribed: {
          let message = "REQUEST: \(requestString)"
          log.debug(message, file: file, function: function, line: line)
        }
      )
  }
}
