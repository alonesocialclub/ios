//
//  Quick+RxVerify.swift
//  AloneSocialClubTests
//
//  Created by Suyeol Jeon on 2019/10/16.
//

import Nimble
@testable import Quick
@testable import RxSwift


// MARK: Verifyinig Number of RxSwift Resources

func verifyRxResourcesAreReleased(
  beforeEach: @escaping (@escaping BeforeExampleClosure) -> Void = Quick.beforeEach,
  afterEach: @escaping (@escaping AfterExampleClosure) -> Void = Quick.afterEach
) {
  var numberOfResourcesByExampleIndex: [Example.Index: Int32] = [:]

  beforeEach {
    let example = currentExample()
    let numberOfResources = RxSwift.Resources.total
    numberOfResourcesByExampleIndex[example.index] = numberOfResources
  }

  afterEach {
    let example = currentExample()
    let expectedNumberOfResources = numberOfResourcesByExampleIndex.removeValue(forKey: example.index)!
    let currentNumberOfResources = RxSwift.Resources.total

    let expectation = expect(currentNumberOfResources, file: example.file, line: example.line)
    expectation.to(haveLessThanOrEqualTo(expectedNumberOfResources, resource: "Rx resources"))
  }
}

func verifyRxResourcesAreReleased(configuration: Configuration) {
  verifyRxResourcesAreReleased(beforeEach: configuration.beforeEach, afterEach: configuration.afterEach)
}


// MARK: Verifyinig Number of Actions in Main Scheduler

func verifyMainSchedulerIsEmpty(
  beforeEach: @escaping (@escaping BeforeExampleClosure) -> Void = Quick.beforeEach,
  afterEach: @escaping (@escaping AfterExampleClosure) -> Void = Quick.afterEach
) {
  var numberOfActionsByExampleIndex: [Example.Index: Int32] = [:]

  beforeEach {
    let example = currentExample()
    let numberOfActions = MainScheduler.instance.numberEnqueued.value
    numberOfActionsByExampleIndex[example.index] = numberOfActions
  }

  afterEach {
    let example = currentExample()
    let expectedNumberOfActions = numberOfActionsByExampleIndex.removeValue(forKey: example.index)!
    let currentNumberOfActions = MainScheduler.instance.numberEnqueued.value

    let expectation = expect(currentNumberOfActions, file: example.file, line: example.line)
    expectation.to(haveLessThanOrEqualTo(expectedNumberOfActions, resource: "scheduled actions in MainScheduler"))
  }
}

func verifyMainSchedulerIsEmpty(configuration: Configuration) {
  verifyMainSchedulerIsEmpty(beforeEach: configuration.beforeEach, afterEach: configuration.afterEach)
}

private extension AtomicInt {
  var value: Int32 {
    let mirror = Mirror(reflecting: self)
    return mirror.children.first { name, _ in name == "value" }!.value as! Int32
  }
}


// MARK: Example

private struct Example {
  typealias Index = Int

  let index: Index
  let file: FileString
  let line: UInt
}

private func currentExample() -> Example {
  let metadata = World.sharedWorld.currentExampleMetadata!
  let callsite = metadata.example.callsite
  return Example(index: metadata.exampleIndex, file: callsite.file, line: callsite.line)
}


// MARK: Matchers

private func haveLessThanOrEqualTo<T>(_ expectedCount: T, resource: String) -> Predicate<T> where T: Comparable {
  let failureMessage = "have less than or equal to <\(stringify(expectedCount))> \(resource) after finishing the test"
  return Predicate.define(failureMessage) { actualExpression, msg in
    let actualValue = try actualExpression.evaluate()
    switch (expectedCount, actualValue) {
    case (nil, _?):
      return PredicateResult(status: .fail, message: msg.appendedBeNilHint())
    case (nil, nil), (_, nil):
      return PredicateResult(status: .fail, message: msg)
    case (let expected, let actual?):
      let matches = actual <= expected
      return PredicateResult(bool: matches, message: msg)
    }
  }
}
