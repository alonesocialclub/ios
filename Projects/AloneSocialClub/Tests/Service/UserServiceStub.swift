//
//  UserServiceStub.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import RxSwift
import Stubber
@testable import AloneSocialClub

final class UserServiceStub: UserServiceProtocol {
  func me() -> Single<User> {
    return Stubber.invoke(me, args: (), default: .error(TestError()))
  }
}
