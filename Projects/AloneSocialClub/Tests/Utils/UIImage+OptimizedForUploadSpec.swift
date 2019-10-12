//
//  UIImage+OptimizedForUploadSpec.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import Nimble
import Quick
@testable import AloneSocialClub

final class UIImage_OptimizedForUploadSpec: QuickSpec {
  override func spec() {
    context("if an image is smaller than the maximum resolution") {
      it("doesn't resize") {
        let originalImage = UIImage.size(width: 1279, height: 1280).image
        let optimizedImage = originalImage.optimizedForUpload()
        expect(optimizedImage.size) == CGSize(width: 1279, height: 1280)
      }
    }

    context("if an image width is greater than the maximum resolution") {
      it("resizes to fit width") {
        let originalImage = UIImage.size(width: 1600, height: 1280).image
        let optimizedImage = originalImage.optimizedForUpload()
        expect(optimizedImage.size) == CGSize(width: 1280, height: 1024)
      }
    }

    context("if an image height is greater than the maximum resolution") {
      it("resizes to fit height") {
        let originalImage = UIImage.size(width: 1280, height: 1600).image
        let optimizedImage = originalImage.optimizedForUpload()
        expect(optimizedImage.size) == CGSize(width: 1024, height: 1280)
      }
    }
  }
}
