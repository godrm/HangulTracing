//
//  LetterViewTests.swift
//  HangulTracingTests
//
//  Created by junwoo on 2017. 11. 7..
//  Copyright © 2017년 samchon. All rights reserved.
//

import XCTest
@testable import HangulTracing

class LetterViewTests: XCTestCase {
  
  var letterView: LetterView!
  
  override func setUp() {
    super.setUp()
    let tracingVC = TracingVC()
    _ = tracingVC.view
    letterView = LetterView(frame: CGRect(x: 0, y: 0, width: 300, height: 600), letter: "가")
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_HasLetterSet() {
    XCTAssertNotNil(letterView.letterSet)
  }
  
  func test_HasScreenPointsSet() {
    XCTAssertNotNil(letterView.screenPointsSet)
  }
  
  func test_HasSpeakerBtn() {
    XCTAssertNotNil(letterView.speakerBtn)
  }
  
  func test_SpeakBtn_HasAction() {
    let speakerBtn = letterView.speakerBtn
    guard let actions = speakerBtn.actions(forTarget: letterView, forControlEvent: .touchUpInside) else { XCTFail(); return }
    XCTAssertTrue(actions.contains("speakerTapped:"))
  }
  
  func test_SpeakerTapped_callSynthesizeApeech() {
    let mockLetterView = MockLetterView(frame: CGRect(), letter: "가")
    let speakerBtn = mockLetterView.speakerBtn
    mockLetterView.speakerTapped(speakerBtn)
    XCTAssertTrue(mockLetterView.synthsizeSpeechIsCalled)
  }
}

extension LetterViewTests {
  class MockLetterView: LetterView {
    var synthsizeSpeechIsCalled = false
    
    override func synthesizeSpeech(fromString string: String) {
      synthsizeSpeechIsCalled = true
      super.synthesizeSpeech(fromString: string)
    }
  }
}
