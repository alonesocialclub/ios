//
//  ASAuthorizationControllerProtocol.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/14.
//

import AuthenticationServices

protocol ASAuthorizationControllerProtocol: class {
  var delegate: ASAuthorizationControllerDelegate? { get set }

  func performRequests()

  init(authorizationRequests: [ASAuthorizationRequest])
}

extension ASAuthorizationController: ASAuthorizationControllerProtocol {
}
