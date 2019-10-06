//
//  FeedViewSection.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import RxDataSources_Texture

struct FeedViewSection: Equatable {
  var items: [Item]
}

extension FeedViewSection: AnimatableSectionModelType {
  var identity: String {
    return "FeedViewSection"
  }

  init(original: FeedViewSection, items: [Item]) {
    self = original
    self.items = items
  }
}

extension FeedViewSection {
  struct Item: Hashable {
    let post: Post
  }
}

extension FeedViewSection.Item: IdentifiableType {
  var identity: String {
    return "\(self.hashValue)"
  }
}
