//
//  SettingsViewController.swift
//  AloneSocialClub
//
//  Created by Suyeol Jeon on 2019/10/28.
//

import UIKit

import AsyncDisplayKit
import Pure
import ReactorKit
import RxDataSources_Texture
import RxSwift

final class SettingsViewController: BaseViewController, View, FactoryModule {

  // MARK: Module

  struct Dependency {
    let reactorFactory: SettingsViewReactor.Factory
    let sceneSwitcher: SceneSwitcher
  }

  struct Payload {
    let reactor: SettingsViewReactor
  }


  // MARK: Constants

  private enum Metric {
  }

  private enum Font {
  }

  private enum Color {
  }


  // MARK: Properties

  private let dependency: Dependency
  private lazy var dataSource = self.createDataSource()


  // MARK: UI

  private let tableNode = ASTableNode(style: .insetGrouped).then {
    $0.backgroundColor = .oc_gray1
  }


  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    defer { self.reactor = payload.reactor }
    self.dependency = dependency
    super.init()
    self.title = "Settings"
  }

  required convenience init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func createDataSource() -> RxASTableSectionedAnimatedDataSource<SettingsViewSection> {
    return .init(configureCellBlock: { dataSource, tableNode, indexPath, sectionItem in
      switch sectionItem {
      case .signOut:
        return { SettingItemCellNode(title: "Sign Out") }
      }
    })
  }


  // MARK: Binding

  func bind(reactor: SettingsViewReactor) {
    self.bindDataSource(reactor: reactor)
    self.bindSignOut(reactor: reactor)
  }

  private func bindDataSource(reactor: SettingsViewReactor) {
    reactor.state.map { $0.sections }
      .distinctUntilChanged()
      .bind(to: self.tableNode.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }

  private func bindSignOut(reactor: SettingsViewReactor) {
    self.tableNode.rx.modelSelected(SettingsViewSection.Item.self)
      .filter { $0 == .signOut }
      .map { _ in Reactor.Action.signOut }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.isSignedOut }
      .filter { $0 == true }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] _ in
        self?.dependency.sceneSwitcher.switch(to: .join)
      })
      .disposed(by: self.disposeBag)
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASWrapperLayoutSpec(layoutElement: self.tableNode)
  }
}
