//
//  PostService.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/12.
//

import RxRelay
import RxSwift

protocol PostServiceProtocol {
  var event: PublishRelay<Post.Event> { get }

  func create(pictureID: String, text: String) -> Single<Post>
  func ping(postID: String, receiverID: String) -> Single<Ping>
}

final class PostService: PostServiceProtocol {
  let event: PublishRelay<Post.Event> = .init()

  private let networking: NetworkingProtocol

  init(networking: NetworkingProtocol) {
    self.networking = networking
  }

  func create(pictureID: String, text: String) -> Single<Post> {
    return self.networking.request(PostAPI.create(pictureID: pictureID, text: text))
      .map(Post.self)
      .do(onSuccess: { [weak self] post in
        self?.event.accept(.create(post))
      })
  }

  func ping(postID: String, receiverID: String) -> Single<Ping> {
    return self.networking.request(PostAPI.ping(postID: postID, receiverID: receiverID))
      .map(Ping.self)
      .do(onSubscribe: { [weak self] in
        self?.event.accept(.ping(postID: postID))
      })
  }
}
