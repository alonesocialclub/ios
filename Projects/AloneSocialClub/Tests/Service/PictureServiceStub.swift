//
//  PictureServiceStub.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import RxSwift
import Stubber
@testable import AloneSocialClub

final class PictureServiceStub: PictureServiceProtocol {
  func upload(image: UIImage) -> Single<Picture> {
    return Stubber.invoke(upload, args: image, default: .error(TestError()))
  }
}
