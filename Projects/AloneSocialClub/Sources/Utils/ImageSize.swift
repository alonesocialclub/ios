//
//  ImageSize.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import UIKit

enum ImageSize: Equatable {
  case full
  case hd
  case large
  case medium
  case thumbnail
  case small
  case tiny
}

extension ImageSize {
  var pointSize: Int {
    switch self {
    case .full: return 1280
    case .hd: return 640
    case .large: return 320
    case .medium: return 200
    case .thumbnail: return 128
    case .small: return 64
    case .tiny: return 40
    }
  }

  var pixelSize: Int {
    return self.pointSize * Int(UIScreen.main.scale)
  }
}
