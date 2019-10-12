//
//  Array+SectionModel.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/12.
//

import RxDataSources

extension Array where Element: SectionModelType, Element.Item: Hashable {
  private typealias Section = Element

  func removingDuplicates() -> [Element] {
    var set = Set<Section.Item>()
    return self.compactMap { section -> Section? in
      let uniqueItems = section.items.filter { set.insert($0).inserted }
      guard !uniqueItems.isEmpty else { return nil }
      return Section(original: section, items: uniqueItems)
    }
  }

  mutating func removeDuplicates() {
    self = self.removingDuplicates()
  }
}
