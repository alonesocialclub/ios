//
//  FeedServiceStub.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import RxSwift
import Stubber
@testable import AloneSocialClub

final class FeedServiceStub: FeedServiceProtocol {
  func feed() -> Single<Feed> {
    return Stubber.invoke(feed, args: (), default: .error(TestError()))
  }
}
