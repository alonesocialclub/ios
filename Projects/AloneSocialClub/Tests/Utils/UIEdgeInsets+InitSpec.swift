//
//  UIEdgeInsets+InitSpec.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import Nimble
import Quick
@testable import AloneSocialClub

final class UIEdgeInsets_InitSpec: QuickSpec {
  override func spec() {
    describe("init()") {
      it("can use an initializer without a parameter") {
        expect(UIEdgeInsets()) == UIEdgeInsets.zero
      }
    }

    describe("init(top:left:bottom:right:)") {
      it("can use the default initializer") {
        let insets = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        expect(insets.top) == 10
        expect(insets.left) == 20
        expect(insets.bottom) == 30
        expect(insets.right) == 40
      }

      it("can use an initializer with optional edge paramters") {
        expect(UIEdgeInsets(top: 100)) == UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        expect(UIEdgeInsets(left: 200)) == UIEdgeInsets(top: 0, left: 200, bottom: 0, right: 0)
        expect(UIEdgeInsets(bottom: 300)) == UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        expect(UIEdgeInsets(right: 400)) == UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 400)
        expect(UIEdgeInsets(top: 1, bottom: 3)) == UIEdgeInsets(top: 1, left: 0, bottom: 3, right: 0)
        expect(UIEdgeInsets(left: 2, right: 4)) == UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 4)
        expect(UIEdgeInsets(top: 10, left: 20, bottom: 30)) == UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 0)
        expect(UIEdgeInsets(top: 10, left: 20, right: 30)) == UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 30)
        expect(UIEdgeInsets(top: 10, bottom: 20, right: 30)) == UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 30)
        expect(UIEdgeInsets(left: 10, bottom: 20, right: 30)) == UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 30)
      }
    }

    describe("init(horizontal:vertical:)") {
      it("can use an initializer that takes horizontal and vertical insets") {
        expect(UIEdgeInsets(horizontal: 10, vertical: 20)) == UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        expect(UIEdgeInsets(horizontal: 100)) == UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100)
        expect(UIEdgeInsets(vertical: 200)) == UIEdgeInsets(top: 200, left: 0, bottom: 200, right: 0)
      }
    }

    describe("init(all:)") {
      it("can use an initializer that takes insets for all edges") {
        expect(UIEdgeInsets(all: 50)) == UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
      }
    }
  }
}
