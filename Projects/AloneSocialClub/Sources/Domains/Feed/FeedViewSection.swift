//
//  FeedViewSection.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import RxDataSources_Texture

struct FeedViewSection: Equatable {
  enum Identity: String {
    case title
    case feed
  }

  let identity: Identity
  let items: [Item]
}

extension FeedViewSection: AnimatableSectionModelType {
  init(original: FeedViewSection, items: [Item]) {
    self = FeedViewSection(identity: original.identity, items: items)
  }
}

extension FeedViewSection {
  enum Item: Hashable {
    case title
    case post(PostCellNodeReactor)
  }
}

extension FeedViewSection.Item: IdentifiableType {
  var identity: String {
    return "\(self.hashValue)"
  }
}
