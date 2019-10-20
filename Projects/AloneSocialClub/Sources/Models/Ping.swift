//
//  Ping.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/20.
//

import Foundation

struct Ping: Decodable, Hashable {
  var sender: User
  var receiver: User
  var postID: String
  var createdAt: Date
  var updatedAt: Date
}
