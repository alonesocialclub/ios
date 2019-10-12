//
//  Feed.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 06/10/2019.
//

struct Feed: Hashable {
  var posts: [Post]
}

extension Feed: Decodable {
  enum CodingKeys: String, CodingKey {
    case posts = "content"
  }
}
