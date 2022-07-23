//
//  ScrollViewModel.swift
//  ScrollRerationToolbar
//
//  Created by 名前なし on 2022/07/24.
//

import Foundation

class ScrollViewModel: ObservableObject {
    @Published public var isShowBottomMenu = false
    var bottomOpacity: Double {
        return isShowBottomMenu ? 1 : 0
    }
}
