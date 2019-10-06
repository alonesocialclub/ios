//
//  FeedService.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import RxSwift

protocol FeedServiceProtocol {
  func feed() -> Single<Feed>
}

final class FeedService: FeedServiceProtocol {
  private let networking: Networking

  init(networking: Networking) {
    self.networking = networking
  }

  func feed() -> Single<Feed> {
    return self.networking.request(FeedAPI.feed)
      .map(Feed.self)
  }
}
