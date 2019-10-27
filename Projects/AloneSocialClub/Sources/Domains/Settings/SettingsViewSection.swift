//
//  SettingsViewSection.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/28.
//

import RxDataSources_Texture

struct SettingsViewSection: Equatable {
  enum Identity: String {
    case basic
  }

  let identity: Identity
  let items: [Item]
}

extension SettingsViewSection: AnimatableSectionModelType {
  init(original: SettingsViewSection, items: [Item]) {
    self = SettingsViewSection(identity: original.identity, items: items)
  }
}

extension SettingsViewSection {
  enum Item: Hashable {
    case signOut
  }
}

extension SettingsViewSection.Item: IdentifiableType {
  var identity: String {
    return "\(self.hashValue)"
  }
}
