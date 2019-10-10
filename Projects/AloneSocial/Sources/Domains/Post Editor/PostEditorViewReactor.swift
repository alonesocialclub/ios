//
//  PostEditorViewReactor.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 09/10/2019.
//

import Pure
import ReactorKit
import RxSwift

final class PostEditorViewReactor: Reactor, FactoryModule, Hashable {
  struct Dependency {
  }

  struct Payload {
    let mode: Mode
  }

  enum Mode: Hashable {
    case new
  }

  enum Action {
    case setImage(UIImage)
    case setText(String)
    case upload
  }

  enum Mutation {
    case setImage(UIImage)
    case setText(String)
  }

  struct State: Hashable {
    let mode: Mode
    var image: UIImage?
    var text: String = ""
  }

  let initialState: State

  init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.initialState = State(mode: payload.mode)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .setImage(image):
      return Observable.just(Mutation.setImage(image))

    case let .setText(text):
      return Observable.just(Mutation.setText(text))

    case .upload:
      return Observable.empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setImage(image):
      newState.image = image

    case let .setText(text):
      newState.text = text
    }
    return newState
  }
}
