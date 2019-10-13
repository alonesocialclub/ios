//
//  AppleAuthService.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/14.
//

import AuthenticationServices

import RxRelay
import RxSwift

protocol AppleAuthServiceProtocol {
  func authenticate() -> Single<AppleIDCredential>
}

final class AppleAuthService: AppleAuthServiceProtocol {
  private let authorizationControllerClass: ASAuthorizationControllerProtocol.Type
  private let authorizationControllerDelegateObject = AuthorizationControllerDelegateObject()

  init(authorizationControllerClass: ASAuthorizationControllerProtocol.Type) {
    self.authorizationControllerClass = authorizationControllerClass
  }

  func authenticate() -> Single<AppleIDCredential> {
    let authorizationControllerClass = self.authorizationControllerClass
    let authorizationControllerDelegateObject = self.authorizationControllerDelegateObject

    return Single.create { observer in
      let provider = ASAuthorizationAppleIDProvider()
      let request = provider.createRequest()
      request.requestedScopes = [.fullName, .email]

      let authorizationController = authorizationControllerClass.init(authorizationRequests: [request])
      authorizationController.delegate = authorizationControllerDelegateObject
      authorizationController.performRequests()

      return authorizationControllerDelegateObject.resultRelay
        .take(1)
        .asSingle()
        .subscribe(onSuccess: { result in
          switch result {
          case let .success(credential):
            observer(.success(credential))
          case let .failure(error):
            observer(.error(error))
          }
        })
    }
  }
}

struct AppleIDCredential: Hashable {
  let userIdentifier: String
  let authorizationCode: String
}

enum AppleIDAuthorizationError: Error, Hashable {
  case noCredential
  case noAuthorizationCode
  case malformedAuthorizationCode
}

private final class AuthorizationControllerDelegateObject: NSObject, ASAuthorizationControllerDelegate {
  let resultRelay = PublishRelay<Result<AppleIDCredential, Error>>()

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
      return self.resultRelay.accept(.failure(AppleIDAuthorizationError.noCredential))
    }
    guard let data = credential.authorizationCode else {
      return self.resultRelay.accept(.failure(AppleIDAuthorizationError.noAuthorizationCode))
    }
    guard let authorizationCode = String(data: data, encoding: .utf8) else {
      return self.resultRelay.accept(.failure(AppleIDAuthorizationError.malformedAuthorizationCode))
    }
    self.resultRelay.accept(.success(AppleIDCredential(
      userIdentifier: credential.user,
      authorizationCode: authorizationCode
    )))
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    self.resultRelay.accept(.failure(error))
  }
}
