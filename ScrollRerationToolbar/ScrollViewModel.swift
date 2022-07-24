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
    @Published public var prevValue = CGFloat(0)
    @Published public var safeAreaTop: CGFloat? = nil
    @Published public var topScrollSpace = CGFloat(50)
    @Published public var bottomSheetCount = Int.zero
    @Published public var headerCount = Int.zero
    @Published public var isStartPosition = true
    @Published public var prevScrollOrientation: ScrollOrientation = .down

    let showBottomLimitCount = 20
    let showHeaderLimitCount = 40

    var isShowBottomSheet: Bool {
        return (self.bottomSheetCount == self.showBottomLimitCount) || isStartPosition
    }

    var isShowHeader: Bool {
        return self.headerCount == self.showHeaderLimitCount || isStartPosition
    }

    var startPosition: CGFloat? {
        guard let safeAreaTop = self.safeAreaTop else { return nil}
        return safeAreaTop + topScrollSpace
    }

    // スクロールが↑ならUIを表示する。
    public func scrollEventHandler(value: CGFloat) {

        print(value)
        guard let startPosition = self.startPosition else { return}
        if value > startPosition { return }

        //MARK: - 初期化
        // 現在のスクロール向きを取得する
        let currentScrollOrientation: ScrollOrientation = (self.prevValue - value) > 0 ? .down : .up

        // 前回の値を更新する
        self.prevValue = value

        // 前回のスクロールの向きを更新する
        prevScrollOrientation = currentScrollOrientation

        //MARK: - ↑スクロール
        if currentScrollOrientation == .up {

            // ボトムが非表示ならインクリメントする
            if isShowBottomSheet == false {
                self.bottomSheetCount += 1
            }
            // ヘッダー非表示ならインクリメントする
            if isShowHeader == false {
                self.headerCount += 1
            }
        }

        //MARK: - スタートポジションにいる
        if value == startPosition {
            if isShowHeader == false && isStartPosition == false {
                isStartPosition = true
            }
            return
        }

        //MARK: - ↓スクロール(非表示にするため値をリセット)
        if currentScrollOrientation == .down {
            isStartPosition = false
            //リセット
            reset()
            return
        }
    }

    private func reset() {
        self.headerCount = 0
        self.bottomSheetCount = 0
    }

}
