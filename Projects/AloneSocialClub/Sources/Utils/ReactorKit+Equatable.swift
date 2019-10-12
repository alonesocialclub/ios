//
//  ReactorKit+Equatable.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 07/10/2019.
//

import ReactorKit

extension Reactor where Self: Equatable, State: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.currentState == rhs.currentState
  }
}
