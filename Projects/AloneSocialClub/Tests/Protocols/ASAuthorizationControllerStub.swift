//
//  ASAuthorizationControllerStub.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/14.
//

import AuthenticationServices

import Stubber
@testable import AloneSocialClub

final class ASAuthorizationControllerStub: ASAuthorizationControllerProtocol {
  let authorizationRequests: [ASAuthorizationRequest]
  weak var delegate: ASAuthorizationControllerDelegate?

  init(authorizationRequests: [ASAuthorizationRequest]) {
    self.authorizationRequests = authorizationRequests
  }

  func performRequests() {
    Stubber.invoke(performRequests, args: (), default: Void())
  }
}
