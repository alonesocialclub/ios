//
//  StringStyle+RawAttributes.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/12.
//

import BonMot

extension StringStyle {
  var rawAttributes: [String: Any] {
    return self.attributes.reduce(into: [:]) { result, attribute in
      result[attribute.key.rawValue] = attribute.value
    }
  }
}
