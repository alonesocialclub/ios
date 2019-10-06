//
//  ReactorKit+Hashable.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import ReactorKit

extension Reactor where Self: Hashable, State: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.currentState.hashValue)
  }
}
