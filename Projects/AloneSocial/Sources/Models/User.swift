//
//  User.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

struct User: Decodable {
  var id: String
  var profile: Profile
}

extension User {
  struct Profile: Decodable {
    var name: String
  }
}
