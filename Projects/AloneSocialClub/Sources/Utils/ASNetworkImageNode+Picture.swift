//
//  ASNetworkImageNode+Picture.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/12.
//

import AsyncDisplayKit
import RxCocoa
import RxSwift

extension ASNetworkImageNode {
  func setImage(with picture: Picture?, size: ImageSize) {
    if let picture = picture {
      self.clearImageAndURL()
      self.url = PictureAPI.image(pictureID: picture.id, width: size.pixelSize).url
    } else {
      if self.defaultImage == nil {
        self.clearImageAndURL()
      }
    }
  }

  private func clearImageAndURL() {
    self.image = nil
    self.url = nil
  }
}

extension Reactive where Base: ASNetworkImageNode {
  func image(size: ImageSize) -> Binder<Picture?> {
    return Binder(self.base) { imageNode, picture in
      imageNode.setImage(with: picture, size: size)
    }
  }
}
