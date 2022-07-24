//
//  ScrollViewModel.swift
//  ScrollRerationToolbar
//
//  Created by 名前なし on 2022/07/24.
//

import Foundation
import SwiftUI

class ScrollViewModel: ObservableObject {

    enum ScrollVector {
        case up, down
        mutating func toggle() {
            self = (self == .up) ? .down : .up
        }
    }
    @Published public var prevScrollAmount: CGFloat? = nil
    @Published public var prev = CGFloat(0)
    @Published public var diff = CGFloat(0)
    @Published public var bottomSheetCount = Int.zero
    @Published public var headerCount = Int.zero

    @Published public var prevScrollVector: ScrollVector? = nil

    let bottomSheetLimitThreshold = 20
    let headerLimitThreshold = 60

    var bottomOpacity: Double {
        return self.bottomSheetCount ==  self.bottomSheetLimitThreshold ? 1 : 0
    }

    var headerOpacity: Double {
        return self.headerCount == self.headerLimitThreshold ? 1 : 0
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

        let currentScrollVector: ScrollVector = (self.prev - value) > 0 ? .down : .up

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

        if prevScrollVector == nil {
            if currentScrollVector == .up   {
                prevScrollVector = .down
            } else {
                prevScrollVector = .up
            }
            return
        }

        if prevScrollVector != currentScrollVector {
            isSwitchVector()
        }
    }

    private func isSwitchVector() {
        self.bottomSheetCount = 0
        self.headerCount = 0
        self.prevScrollVector?.toggle()
    }
}
