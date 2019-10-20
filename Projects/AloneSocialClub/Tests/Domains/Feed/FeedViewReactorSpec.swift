//
//  FeedViewReactorSpec.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import Pure
@testable import AloneSocialClub

extension Factory where Module == FeedViewReactor {
  static func dummy() -> Factory {
    return .init(dependency: .init(
      feedService: FeedServiceStub(),
      postService: PostServiceStub(),
      postCellNodeReactorFactory: .dummy()
    ))
  }
}
