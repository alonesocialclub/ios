//
//  PostService.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 2019/10/12.
//

import RxSwift

protocol PostServiceProtocol {
  func create(pictureID: String, text: String) -> Single<Post>
}

final class PostService: PostServiceProtocol {
  private let networking: NetworkingProtocol

  init(networking: NetworkingProtocol) {
    self.networking = networking
  }

  func create(pictureID: String, text: String) -> Single<Post> {
    return self.networking.request(PostAPI.create(pictureID: pictureID, text: text))
      .map(Post.self)
  }
}
