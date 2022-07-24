//
//  ScrollViewModel.swift
//  ScrollRerationToolbar
//
//  Created by 名前なし on 2022/07/24.
//

import Foundation
import SwiftUI

class ScrollViewModel: ObservableObject {

    enum ScrollOrientation {
        case up, down
        mutating func toggle() {
            self = (self == .up) ? .down : .up
        }
    }
    @Published public var prevScrollAmount: CGFloat? = nil
    @Published public var prev = CGFloat(0)
    @Published public var safeAreaTop: CGFloat? = nil
    @Published public var topScrollSpace = CGFloat(50)
    @Published public var diff = CGFloat(0)
    @Published public var bottomSheetCount = Int.zero
    @Published public var headerCount = Int.zero
    @Published public var isFirstPosition = true
    @Published public var prevScrollOrientation: ScrollOrientation? = nil

    let bottomSheetLimitThreshold = 20
    let headerLimitThreshold = 40

    var isShowBottomSheet: Bool {
        return self.bottomSheetCount == self.bottomSheetLimitThreshold || isFirstPosition
    }

    var isShowHeader: Bool {
        return self.headerCount == self.headerLimitThreshold || isFirstPosition
    }

    private func isScorllUp(_ value: CGFloat) -> Bool {
        let diff = self.prev - value
        if diff > 0 {
            return false
        } else {
            return true
        }
    }
    public func scrollEventHandler(value: CGFloat) {

        guard let safeAreaTop = self.safeAreaTop else { return }

        print(safeAreaTop + topScrollSpace)
        if value == safeAreaTop + topScrollSpace {
            isFirstPosition = true
        } else {
            isFirstPosition = false
        }

        let currentScrollVector: ScrollOrientation = (self.prev - value) > 0 ? .down : .up

        if currentScrollVector == .up {

            if self.bottomSheetCount >= bottomSheetLimitThreshold {
                self.bottomSheetCount = bottomSheetLimitThreshold
            } else {
                self.bottomSheetCount += 1
            }

            if self.headerCount >= headerLimitThreshold {
                self.headerCount = headerLimitThreshold
            } else {
                self.headerCount += 1
            }

        } else {
            self.headerCount = 0
            self.bottomSheetCount = 0
        }

        self.prev = value

        if prevScrollOrientation == nil {
            if currentScrollVector == .up   {
                prevScrollOrientation = .down
            } else {
                prevScrollOrientation = .up
            }
            return
        }

        if prevScrollOrientation != currentScrollVector {
            isSwitchVector()
        }
    }

    private func isSwitchVector() {
        self.bottomSheetCount = 0
        self.headerCount = 0
        self.prevScrollOrientation?.toggle()
    }
}
