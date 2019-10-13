//
//  JoinViewReactorSpec.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/13.
//

import Moya
import Nimble
import Pure
import Quick
import Stubber
@testable import AloneSocialClub

final class JoinViewReactorSpec: QuickSpec {
  override func spec() {
    func createReactor(
      authService: AuthServiceStub = .init(),
      appleAuthService: AppleAuthServiceStub = .init()
    ) -> JoinViewReactor {
      let factory = JoinViewReactor.Factory(dependency: .init(
        authService: AuthServiceStub(),
        appleAuthService: AppleAuthServiceStub()
      ))
      return factory.create()
    }

    context("when initialized") {
      it("doesn't have an error message") {
        let reactor = createReactor()
        expect(reactor.currentState.errorMessage).to(beNil())
      }
    }

    context("when receives .signInWithApple action") {
//      var authService: AppleAuthServiceStub!
//      var appleAuthService: AppleAuthServiceStub!
//
//      beforeEach {
//        authService = AppleAuthServiceStub()
//        appleAuthService = AppleAuthServiceStub()
//      }

      it("attempts to authenticate with apple id") {
        // given
        let appleAuthService = AppleAuthServiceStub()
        Stubber.register(appleAuthService.authenticate) {
          return .error(TestError())
        }

        let reactor = createReactor(appleAuthService: appleAuthService)

        // when
        reactor.action.onNext(.signInWithApple)

        // then
        let executions = Stubber.executions(appleAuthService.authenticate)
        expect(executions).to(haveCount(1))
      }

      context("when fails to authenticate with apple id") {
        it("sets an error message") {
          // given
          let appleAuthService = AppleAuthServiceStub()
          Stubber.register(appleAuthService.authenticate) {
            return .error(TestError(description: "apple auth failed"))
          }

          let reactor = createReactor(appleAuthService: appleAuthService)

          // when
          reactor.action.onNext(.signInWithApple)

          // then
          expect(reactor.currentState.errorMessage) == "apple auth failed"
        }
      }

      context("when succeeds to authenticate with apple id") {
        var appleAuthService: AppleAuthServiceStub!

        beforeEach {
          appleAuthService = AppleAuthServiceStub()
          Stubber.register(appleAuthService.authenticate) {
            return .just(AppleIDCredential(
              userIdentifier: "user-identifier",
              authorizationCode: "authorization-code",
              displayName: "display-name"
            ))
          }
        }

        it("attempts to log in with apple credential") {
          // given
          let authService = AuthServiceStub()
          let reactor = createReactor(authService: authService, appleAuthService: appleAuthService)

          // when
          reactor.action.onNext(.signInWithApple)

          // then
          let executions = Stubber.executions(authService.loginWithApple)
          expect(executions).to(haveCount(1))
          expect(executions.first?.arguments.0) == "user-identifier"
          expect(executions.first?.arguments.1) == "authorization-code"
        }

        context("when succeeds to log in with apple credential") {
          it("marks as authenticated") {
            // given
            let authService = AuthServiceStub()
            Stubber.register(authService.loginWithApple) { _, _ in
              return .just(UserFixture.devxoul)
            }

            let reactor = createReactor(authService: authService, appleAuthService: appleAuthService)

            // when
            reactor.action.onNext(.signInWithApple)

            // then
            expect(reactor.currentState.isAuthenticated) == true
          }
        }

        context("when fails to log in with apple credential without 401 error") {
          it("sets an error message") {
            // given
            let authService = AuthServiceStub()
            Stubber.register(authService.loginWithApple) { _, _ in
              return .error(TestError(description: "unknown-error"))
            }

            let reactor = createReactor(authService: authService, appleAuthService: appleAuthService)

            // when
            reactor.action.onNext(.signInWithApple)

            // then
            expect(reactor.currentState.errorMessage) == "unknown-error"
          }
        }

        context("when fails to log in with apple credential with 401 error") {
          var authService: AuthServiceStub!

          beforeEach {
            authService = AuthServiceStub()
            Stubber.register(authService.loginWithApple) { _, _ in
              return .error(MoyaError(statusCode: 401))
            }
          }

          it("attempts to join with the name from the apple credential") {
            // given
            let reactor = createReactor(authService: authService, appleAuthService: appleAuthService)

            // when
            reactor.action.onNext(.signInWithApple)

            // then
            let executions = Stubber.executions(authService.join)
            expect(executions).to(haveCount(1))
            expect(executions.first?.arguments) == "display-name"
          }

          context("when fails to join") {
            it("sets an error message") {
              // given
              Stubber.register(authService.join) { _ in
                return .error(TestError(description: "failed to join"))
              }

              let reactor = createReactor(authService: authService, appleAuthService: appleAuthService)

              // when
              reactor.action.onNext(.signInWithApple)

              // then
              expect(reactor.currentState.errorMessage) == "failed to join"
            }
          }

          context("when succeeds to join") {
            beforeEach {
              Stubber.register(authService.join) { _ in
                return .just(UserFixture.devxoul)
              }
            }

            it("attempts to connect the apple credential") {
              // given
              let reactor = createReactor(authService: authService, appleAuthService: appleAuthService)

              // when
              reactor.action.onNext(.signInWithApple)

              // then
              let executions = Stubber.executions(authService.connectAppleCredential)
              expect(executions).to(haveCount(1))
              expect(executions.first?.arguments.0) == "user-identifier"
              expect(executions.first?.arguments.1) == "authorization-code"
            }

            context("when fails to connect the apple credentials") {
              it("sets an error message") {
                // given
                Stubber.register(authService.connectAppleCredential) { _, _ in
                  return .error(TestError(description: "failed to connect apple credential"))
                }

                let reactor = createReactor(authService: authService, appleAuthService: appleAuthService)

                // when
                reactor.action.onNext(.signInWithApple)

                // then
                expect(reactor.currentState.errorMessage) == "failed to connect apple credential"
              }
            }

            context("when succeeds to connect the apple credentials") {
              it("marks as authenticated") {
                // given
                Stubber.register(authService.connectAppleCredential) { _, _ in
                  return .just(Void())
                }

                let reactor = createReactor(authService: authService, appleAuthService: appleAuthService)

                // when
                reactor.action.onNext(.signInWithApple)

                // then
                expect(reactor.currentState.isAuthenticated) == true
              }
            }
          }
        }
      }
    }
  }
}

extension Factory where Module == JoinViewReactor {
  static func dummy() -> Factory {
    return .init(dependency: .init(
      authService: AuthServiceStub(),
      appleAuthService: AppleAuthServiceStub()
    ))
  }
}
