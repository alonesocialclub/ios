//
//  UIImage+EmptyAvatarSpec.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import Nimble
import Quick
@testable import AloneSocialClub

final class UIImage_EmptyAvatarSpec: QuickSpec {
  override func spec() {
    describe("emptyAvatar") {
      it("returns an empty avatar image") {
        expect(UIImage.emptyAvatar) === UIImage(named: "img-empty_avatar")
      }
    }
  }
}
