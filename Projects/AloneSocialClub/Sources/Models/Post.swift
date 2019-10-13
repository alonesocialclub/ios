//
//  Post.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import Foundation

struct Post: Decodable, Hashable {
  var id: String
  var text: String
  var picture: Picture
  var author: User
  var createdAt: Date
}

extension Post {
  enum Event {
    case create(Post)
  }
}
