//
//  UserService.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import RxSwift

protocol UserServiceProtocol {
  func me() -> Single<User>
}

final class UserService: UserServiceProtocol {
  private let networking: NetworkingProtocol

  init(networking: NetworkingProtocol) {
    self.networking = networking
  }

  func me() -> Single<User> {
    return self.networking.request(UserAPI.me).map(User.self)
  }
}
