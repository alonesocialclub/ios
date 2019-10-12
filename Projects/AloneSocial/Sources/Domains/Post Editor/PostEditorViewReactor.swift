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
    let pictureService: PictureServiceProtocol
    let postService: PostServiceProtocol
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
    case submit
  }

  enum Mutation {
    case setImage(UIImage)
    case setText(String)
    case setLoading(Bool)
    case setSubmitted
    case setError(Error)
  }

  struct State: Hashable {
    let mode: Mode
    var image: UIImage?
    var text: String = ""
    var isLoading: Bool = false
    var isSubmitted: Bool = false
    var errorMessage: String?
  }

  private let dependency: Dependency
  let initialState: State

  init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.dependency = dependency
    self.initialState = State(mode: payload.mode)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .setImage(image):
      return Observable.just(Mutation.setImage(image))

    case let .setText(text):
      return Observable.just(Mutation.setText(text))

    case .submit:
      return Observable.concat([
        Observable.just(Mutation.setLoading(true)),
        self.upload(),
        Observable.just(Mutation.setLoading(false)),
      ])
    }
  }

  private func upload() -> Observable<Mutation> {
    guard let image = self.currentState.image else { return .empty() }
    let text = self.currentState.text

    let dependency = self.dependency
    return dependency.pictureService.upload(image: image)
      .flatMap { picture in
        dependency.postService.create(pictureID: picture.id, text: text)
      }
      .map { _ in Mutation.setSubmitted }
      .catchError { error in .just(Mutation.setError(error)) }
      .asObservable()
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setImage(image):
      newState.image = image

    case let .setText(text):
      newState.text = text

    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case .setSubmitted:
      newState.isSubmitted = true

    case let .setError(error):
      newState.errorMessage = error.localizedDescription
    }
    return newState
  }
}
