//
//  UIImage+OptimizedForUpload.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 2019/10/12.
//

import UIKit

extension UIImage {
  private static let maximumResolution: CGFloat = 1280

  func optimizedForUpload() -> UIImage {
    guard self.needsResize() else { return self }
    let newSize = self.scaledSize()

    UIGraphicsBeginImageContext(newSize)
    defer { UIGraphicsEndImageContext() }

    let rect = CGRect(origin: .zero, size: newSize)
    self.draw(in: rect)

    guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return self }
    return result
  }

  private func needsResize() -> Bool {
    return self.size.width > Self.maximumResolution && self.size.height > Self.maximumResolution
  }

  private func scaledSize() -> CGSize {
    let aspectRatio = self.size.width / self.size.height
    if aspectRatio > 1 {
      return CGSize(width: Self.maximumResolution, height: Self.maximumResolution / aspectRatio)
    } else {
      return CGSize(width: Self.maximumResolution * aspectRatio, height: Self.maximumResolution)
    }
  }
}
