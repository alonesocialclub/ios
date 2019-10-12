//
//  Array+SectionModelSpec.swift.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import Nimble
import Quick
import RxDataSources_Texture
@testable import AloneSocialClub

final class Array_SectionModelSpec: QuickSpec {
  override func spec() {
    describe("removingDuplicates()") {
      it("returns a new array without any duplicates") {
        // given
        let sections: [MySection] = [
          MySection(identity: .heading, items: [.title("A"), .post("a"), .post("b"), .post("c")]),
          MySection(identity: .heading, items: [.title("A"), .post("a")]),
          MySection(identity: .feed, items: [.title("A"), .title("B"), .post("a"), .post("d")]),
          MySection(identity: .feed, items: [.title("B"), .post("b")]),
        ]

        // when
        let newSections = sections.removingDuplicates()

        // then
        expect(newSections) == [
          MySection(identity: .heading, items: [.title("A"), .post("a"), .post("b"), .post("c")]),
          MySection(identity: .feed, items: [.title("B"), .post("d")]),
        ]
      }
    }

    describe("removeDuplicates()") {
      it("removes all duplicates") {
        // given
        var sections: [MySection] = [
          MySection(identity: .heading, items: [.title("A"), .post("a"), .post("b"), .post("c")]),
          MySection(identity: .heading, items: [.title("A"), .post("a")]),
          MySection(identity: .feed, items: [.title("A"), .title("B"), .post("a"), .post("d")]),
          MySection(identity: .feed, items: [.title("B"), .post("b")]),
        ]

        // when
        sections.removeDuplicates()

        // then
        expect(sections) == [
          MySection(identity: .heading, items: [.title("A"), .post("a"), .post("b"), .post("c")]),
          MySection(identity: .feed, items: [.title("B"), .post("d")]),
        ]
      }
    }
  }
}

private struct MySection: Equatable {
  enum Identity: String {
    case heading
    case feed
  }

  let identity: Identity
  let items: [Item]
}

extension MySection: AnimatableSectionModelType {
  init(original: MySection, items: [Item]) {
    self = MySection(identity: original.identity, items: items)
  }
}

private extension MySection {
  enum Item: Hashable {
    case title(String)
    case post(String)
  }
}

extension MySection.Item: IdentifiableType {
  var identity: String {
    return "\(self.hashValue)"
  }
}
