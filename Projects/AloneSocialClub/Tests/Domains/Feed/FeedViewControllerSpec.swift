//
//  FeedViewControllerSpec.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import Pure
@testable import AloneSocialClub

extension Factory where Module == FeedViewController {
  static func dummy() -> Factory {
    return .init(dependency: .init(
      reactorFactory: .dummy(),
      titleCellNodeFactory: .init(dependency: .init(
        postEditorViewControllerFactory: .dummy(),
        navigator: NavigatorStub(),
        currentUser: CurrentUser()
      )),
      postCellNodeFactory: .init(dependency: .init())
    ))
  }
}
