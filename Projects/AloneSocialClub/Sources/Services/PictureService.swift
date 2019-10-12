//
//  PictureService.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/12.
//

import RxSwift

protocol PictureServiceProtocol {
  func upload(image: UIImage) -> Single<Picture>
}

final class PictureService: PictureServiceProtocol {
  private let networking: NetworkingProtocol

  init(networking: NetworkingProtocol) {
    self.networking = networking
  }

  func upload(image: UIImage) -> Single<Picture> {
    return self.networking.request(PictureAPI.upload(image))
      .map(Picture.self)
  }
}
