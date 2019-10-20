//
//  PostCellNodeReactor.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/20.
//

import Pure
import ReactorKit
import RxSwift

final class PostCellNodeReactor: Reactor, FactoryModule, Hashable {
  struct Dependency {
    let postService: PostServiceProtocol
  }

  struct Payload {
    let post: Post
  }

  enum Action {
    case ping
  }

  enum Mutation {
    case setSendingPing(Bool)
  }

  struct State: Hashable {
    let post: Post
    var isSendingPing: Bool = false
  }

  private let dependency: Dependency
  let initialState: State

  init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.initialState = State(post: payload.post)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .ping:

        .asObservable()
        .flatMap { _ in .empty() }
    }
  }

  private func ping() -> Single<Mutation> {
    let postID = self.currentState.post.id
    let authorID = self.currentState.post.author.id
    return self.dependency.postService.ping(postID: postID, receiverID: authorID)
  }

  func reduce(state: State, mutation: Mutation) -> State {
    return state
  }
}
