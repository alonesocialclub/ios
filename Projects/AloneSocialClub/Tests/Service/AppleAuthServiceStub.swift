//
//  AppleAuthServiceStub.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/14.
//

import RxSwift
import Stubber
@testable import AloneSocialClub

final class AppleAuthServiceStub: AppleAuthServiceProtocol {
  func authenticate() -> Single<AppleIDCredential> {
    return Stubber.invoke(authenticate, args: (), default: .error(TestError()))
  }
}
