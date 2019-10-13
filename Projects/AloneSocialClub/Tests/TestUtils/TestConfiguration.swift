//
//  TestConfiguration.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/14.
//

import Quick
import Stubber

class TestConfiguration: QuickConfiguration {
  override class func configure(_ configuration: Configuration) {
    configuration.beforeEach {
      Stubber.clear()
    }
  }
}
