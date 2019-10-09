//
//  CompositionRoot.swift
//  AloneSocial
//
//  Created by Suyeol Jeon on 06/10/2019.
//

import KeychainAccess
import Pure
import ReactorKit
import Swinject
import SwinjectAutoregistration

struct AppDependency {
  let window: UIWindow
  let splashViewControllerFactory: SplashViewController.Factory
}

extension AppDependency {
  private static let container = Container()

  static func resolve() -> AppDependency {
    self.registerNetworking()
    self.registerServices()
    self.registerViewControllers()
    self.registerScene()

    self.container.autoregister(AppDependency.self, initializer: AppDependency.init)
    return self.container.resolve(AppDependency.self)!
  }
}

private extension AppDependency {
  static func registerNetworking() {
    self.container.register(KeychainProtocol.self) { _ in Keychain() }
    self.container.autoregister(AuthTokenStore.self, initializer: AuthTokenStore.init)
    self.container.autoregister(AuthPlugin.self, initializer: AuthPlugin.init)
    self.container.autoregister(NetworkingProtocol.self, initializer: Networking.init)
  }
}

private extension AppDependency {
  static func registerServices() {
    self.container.autoregister(AuthServiceProtocol.self, initializer: AuthService.init)
    self.container.autoregister(UserServiceProtocol.self, initializer: UserService.init)
    self.container.autoregister(FeedServiceProtocol.self, initializer: FeedService.init)
  }
}

private extension AppDependency {
  static func registerViewControllers() {
    self.register(SplashViewReactor.self, dependency: SplashViewReactor.Dependency.init)
    self.register(SplashViewController.self, dependency: SplashViewController.Dependency.init)

    self.register(JoinViewReactor.self, dependency: JoinViewReactor.Dependency.init)
    self.register(JoinViewController.self, dependency: JoinViewController.Dependency.init)

    self.register(PostCellNode.self, dependency: PostCellNode.Dependency.init)
    self.register(FeedViewReactor.self, dependency: FeedViewReactor.Dependency.init)
    self.register(FeedViewController.self, dependency: FeedViewController.Dependency.init)

    self.register(PostEditorViewReactor.self, dependency: PostEditorViewReactor.Dependency.init)
    self.register(PostEditorViewController.self, dependency: PostEditorViewController.Dependency.init)
  }
}

private extension AppDependency {
  static func registerScene() {
    self.container.register(UIWindow.self) { _ in UIWindow() }
    self.container.autoregister(SceneSwitcher.self, initializer: SceneSwitcher.init).initCompleted { r, sceneSwitcher in
      sceneSwitcher.joinViewControllerFactory = r.resolve(JoinViewController.Factory.self)
      sceneSwitcher.feedViewControllerFactory = r.resolve(FeedViewController.Factory.self)
    }
  }
}


// MARK: Swinject+FactoryModule

private extension AppDependency {
  private static func register<Module, Arg1>(_ module: Module.Type, dependency: @escaping (Arg1) -> Module.Dependency) where Module: FactoryModule {
    if Arg1.self == Void.self {
      self.container.register(Void.self) { _ in Void() }
    }
    self.container.autoregister(Module.Dependency.self, initializer: dependency)
    self._register(module)
  }

  private static func register<Module, Arg1, Arg2>(_ module: Module.Type, dependency: @escaping ((Arg1, Arg2)) -> Module.Dependency) where Module: FactoryModule {
    self.container.autoregister(Module.Dependency.self, initializer: dependency)
    self._register(module)
  }

  private static func register<Module, Arg1, Arg2, Arg3>(_ module: Module.Type, dependency: @escaping (Arg1, Arg2, Arg3) -> Module.Dependency) where Module: FactoryModule {
    self.container.autoregister(Module.Dependency.self, initializer: dependency)
    self._register(module)
  }

  private static func register<Module, Arg1, Arg2, Arg3, Arg4>(_ module: Module.Type, dependency: @escaping (Arg1, Arg2, Arg3, Arg4) -> Module.Dependency) where Module: FactoryModule {
    self.container.autoregister(Module.Dependency.self, initializer: dependency)
    self._register(module)
  }

  private static func register<Module, Arg1, Arg2, Arg3, Arg4, Arg5>(_ module: Module.Type, dependency: @escaping (Arg1, Arg2, Arg3, Arg4, Arg5) -> Module.Dependency) where Module: FactoryModule {
    self.container.autoregister(Module.Dependency.self, initializer: dependency)
    self._register(module)
  }

  private static func _register<Module>(_ module: Module.Type) where Module: FactoryModule {
    self.container.register((() -> Module.Dependency).self) { r in
      // If the dependency is resolved lazily, the container cannot verify missing dependencies.
      // But it can cause overhead so we need to find a better solution in the future.
      let dependency = r.resolve(Module.Dependency.self)!
      return { dependency }
    }
    self.container.autoregister(Factory<Module>.self, initializer: Factory<Module>.init)
  }
}
