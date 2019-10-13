//
//  Moya+Codable.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/14.
//

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
  private static let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom(Self.decodeDate)
    return decoder
  }()

  private static func decodeDate(_ decoder: Decoder) throws -> Date {
    let container = try decoder.singleValueContainer()
    let dateString = try container.decode(String.self)
    let dateFormatters: [DateFormatter] = [
      DateFormatter().with { $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" },
      DateFormatter().with { $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" },
      DateFormatter().with { $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS" },
      DateFormatter().with { $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" },
      DateFormatter().with { $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" },
      DateFormatter().with { $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" },
    ]
    for dateFormatter in dateFormatters {
      guard let date = dateFormatter.date(from: dateString) else { continue }
      return date
    }
    return try container.decode(Date.self)
  }

  func map<T: Decodable>(_ type: T.Type, atKeyPath keyPath: String? = nil) -> Single<T> {
    return self.map(type, atKeyPath: keyPath, using: Self.jsonDecoder)
    .do(onError: {
      if case let MoyaError.objectMapping(error, response) = $0 {
        let body: Any = (try? response.mapJSON()) ?? (try? response.mapString()) ?? response.data
        log.error(error, body)
      }
    })
  }
}
