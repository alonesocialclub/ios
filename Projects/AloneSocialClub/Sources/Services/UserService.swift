//
//  UserService.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import RxRelay
import RxSwift

protocol UserServiceProtocol {
  func me() -> Single<User>
}

final class UserService: UserServiceProtocol {
  private let networking: NetworkingProtocol
  private let currentUser: CurrentUser

  init(networking: NetworkingProtocol, currentUser: CurrentUser) {
    self.networking = networking
    self.currentUser = currentUser
  }

  func me() -> Single<User> {
    return self.networking.request(UserAPI.me)
      .map(User.self)
      .do(onSuccess: { [weak self] newUser in
        self?.currentUser.value = newUser
      })
  }
}
