// BlurringOverlayStyleManagerTest.swift
//
// Copyright (c) 2017 Frédéric Maquin <fred@ephread.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import XCTest
@testable import Instructions

class BlurringOverlayStyleManagerTest: XCTestCase {

    private let overlayView = OverlayView()
    private let blurringStyleManager = BlurringOverlayStyleManager(style: .extraLight)
    private let  snapshotDelegate = SnapshotDelegate()

    var viewIsVisibleExpectation: XCTestExpectation? = nil

    override func setUp() {
        super.setUp()
        overlayView.frame = CGRect(x: 0, y: 0, width: 365, height: 667)
        overlayView.alpha = 0.0

        blurringStyleManager.overlayView = overlayView
        blurringStyleManager.snapshotDelegate = snapshotDelegate
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testThatOverlayIsShown() {
        self.viewIsVisibleExpectation = self.expectation(description: "viewIsVisible")

        blurringStyleManager.showOverlay(true, withDuration: 1.0) { _ in
            XCTAssertEqual(self.overlayView.alpha, 1.0)
            XCTAssertEqual(self.overlayView.isHidden, false)

            let containsBlur = self.overlayView.holder.subviews
                                               .filter { $0 is UIVisualEffectView }
                                               .count == 2

            XCTAssertTrue(containsBlur)

            self.viewIsVisibleExpectation?.fulfill()
        }

        self.waitForExpectations(timeout: 1.1) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatOverlayIsHidden() {
        viewIsVisibleExpectation = expectation(description: "viewIsVisible")

        blurringStyleManager.showOverlay(false, withDuration: 1.0) { _ in
            XCTAssertEqual(self.overlayView.alpha, 0.0)

            XCTAssertTrue(self.overlayView.holder.subviews.count == 1)

            self.viewIsVisibleExpectation?.fulfill()
        }

        self.waitForExpectations(timeout: 1.1) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

fileprivate class SnapshotDelegate: Snapshottable {
    func snapshot() -> UIView? {
        return UIView()
    }
}
