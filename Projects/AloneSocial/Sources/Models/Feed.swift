//
//  Feed.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

struct Feed {
  var posts: [Post]
}

extension Feed: Decodable {
  enum CodingKeys: String, CodingKey {
    case posts = "content"
  }
}
