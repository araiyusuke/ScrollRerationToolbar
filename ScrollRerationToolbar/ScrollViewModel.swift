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
    }
    @Published public var prevScrollAmount: CGFloat? = nil
    @Published public var isShowBottomMenu = false
    @Published public var offsetY = CGFloat(0)
    @Published public var currentVector: ScrollVector? = nil

    @Published public var isSwitchScrollVector = false
    var bottomOpacity: Double {
        return isShowBottomMenu ? 1 : 0
    }

    public func getScrollVector(value: CGFloat) {

        let prevDiff = self.offsetY - value

        if currentVector == nil {
            if prevDiff > 0 {
                currentVector = .down
            } else {
                currentVector = .up
            }
            return 
        }

        if prevDiff > 0 {
            if currentVector == .up {
                currentVector = .down
            }
        } else {
            if currentVector == .down {
                currentVector = .up
            }
        }
    }
}
