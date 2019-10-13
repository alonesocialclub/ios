//
//  TestError.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import Foundation

struct TestError: LocalizedError, Hashable {
  let errorDescription: String?

  init(description: String? = nil) {
    self.errorDescription = description
  }
}
