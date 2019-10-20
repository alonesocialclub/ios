//
//  FeedViewReactor.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import Pure
import ReactorKit
import RxSwift

final class FeedViewReactor: Reactor, FactoryModule {
  struct Dependency {
    let feedService: FeedServiceProtocol
    let postService: PostServiceProtocol
    let postCellNodeReactorFactory: PostCellNodeReactor.Factory
  }

  enum Action {
    case refresh
  }

  enum Mutation {
    case setRefreshing(Bool)
    case setFeed(Feed)
    case prependPost(Post)
    case updateSections
  }

  struct State {
    var isRefreshing: Bool = false
    var sections: [FeedViewSection] = [FeedViewSection(identity: .title, items: [.title])]

    fileprivate var postCellReactors: [PostCellNodeReactor] = []
  }

  private let dependency: Dependency
  let initialState: State

  init(dependency: Dependency, payload: Payload) {
    defer { _ = self.state }
    self.dependency = dependency
    self.initialState = State()
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      return Observable.concat([
        Observable.just(Mutation.setRefreshing(true)),
        self.fetchPosts(),
        Observable.just(Mutation.updateSections),
        Observable.just(Mutation.setRefreshing(false)),
      ])
    }
  }

  private func fetchPosts() -> Observable<Mutation> {
    return self.dependency.feedService.feed()
      .map(Mutation.setFeed)
      .asObservable()
      .catchError { _ in .empty() }
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(mutation, self.postServiceMutation())
  }

  private func postServiceMutation() -> Observable<Mutation> {
    return self.dependency.postService.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .create(post):
        return Observable.concat([
          Observable.just(Mutation.prependPost(post)),
          Observable.just(Mutation.updateSections),
        ])

      default:
        return Observable.empty()
      }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setRefreshing(isRefreshing):
      newState.isRefreshing = isRefreshing

    case let .setFeed(feed):
      newState.postCellReactors = feed.posts.map {
        self.dependency.postCellNodeReactorFactory.create(payload: .init(post: $0))
      }

    case let .prependPost(post):
      let cellReactor = self.dependency.postCellNodeReactorFactory.create(payload: .init(post: post))
      newState.postCellReactors.insert(cellReactor, at: 0)

    case .updateSections:
      newState.sections.removeAll()
      defer { newState.sections.removeDuplicates() }

      newState.sections.append(FeedViewSection(identity: .title, items: [.title]))

      if !newState.postCellReactors.isEmpty {
        let items = newState.postCellReactors.map(FeedViewSection.Item.post)
        let section = FeedViewSection(identity: .feed, items: items)
        newState.sections.append(section)
      }
    }

    return newState
  }
}
