//
//  Post.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 06/10/2019.
//

struct Post: Decodable, Hashable {
  var id: String
  var text: String
  var picture: Picture
  var author: User
}

extension Post {
  enum Event {
    case create(Post)
  }
}
