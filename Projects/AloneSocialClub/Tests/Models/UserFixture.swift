//
//  UserFixture.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/14.
//

@testable import AloneSocialClub

enum UserFixture {
  static let devxoul = User(
    id: "user-devxoul-id",
    profile: User.Profile(
      name: "Suyeol Jeon",
      picture: Picture(
        id: "picture-devxoul-id"
      )
    )
  )
}
