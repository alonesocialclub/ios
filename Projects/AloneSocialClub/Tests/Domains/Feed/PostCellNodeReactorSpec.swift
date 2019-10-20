//
//  PostCellNodeReactorSpec.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/20.
//

import Pure
@testable import AloneSocialClub

extension Factory where Module == PostCellNodeReactor {
  static func dummy() -> Factory {
    return .init(dependency: .init(
      postService: PostServiceStub()
    ))
  }
}
