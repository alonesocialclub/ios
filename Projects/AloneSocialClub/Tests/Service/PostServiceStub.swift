//
//  PostServiceStub.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import RxRelay
import RxSwift
import Stubber
@testable import AloneSocialClub

final class PostServiceStub: PostServiceProtocol {
  var event: PublishRelay<Post.Event> = .init()

  func create(pictureID: String, text: String) -> Single<Post> {
    return Stubber.invoke(create, args: (pictureID, text), default: .error(TestError()))
  }
}
