//
//  CurrentUser.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/14.
//

import RxRelay
import RxSwift

final class CurrentUser: ObservableType {
  private let relay = BehaviorRelay<User?>(value: nil)

  var value: User? {
    get { return self.relay.value }
    set {
      guard self.relay.value != newValue else { return }
      self.relay.accept(newValue)
    }
  }

  func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == User? {
    return self.relay.subscribe(observer)
  }

  func asObservable() -> Observable<User?> {
    return self.relay.asObservable()
  }
}
