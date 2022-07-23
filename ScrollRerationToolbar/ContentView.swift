//
//  ContentView.swift
//  ScrollRerationToolbar
//
//  Created by 名前なし on 2022/07/23.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel = ScrollViewModel()
    @State private var offsetY = CGFloat(0)

    struct ScrollAmountPreferenceKey: PreferenceKey {

        // 子から親に渡す値の型
        typealias Value = [CGFloat]

        // PreferenceKeyは必ず実装
        static var defaultValue: Value = [0]

        // PreferenceKeyは必ず実装
        // inout -> 参照　nextValue -> 親に渡す値
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value.append(contentsOf: nextValue())
        }
    }

    var body: some View {
        ZStack(alignment: .top ){

            header.zIndex(.infinity)

            ZStack(alignment: .bottom) {
                ScrollView() {
                    scrollContents
                }
                bottom
            }
        }
        .background(Color.red)
        .ignoresSafeArea(edges: [.top, .bottom])
        .onPreferenceChange(ScrollAmountPreferenceKey.self) { value in

            print(value)

            if value[0] < 130 && value[0] >= 0{
                return
            }

            let prevDiff = self.offsetY - value[0]

            if prevDiff > 0 {
                self.viewModel.isShowBottomMenu = false
            } else {
                self.viewModel.isShowBottomMenu = true
            }

            if value[0] >= 50 {
                self.viewModel.isShowBottomMenu = true
            }

            self.offsetY = value[0]

        }
    }

    var scrollContents: some View {

        ZStack(alignment: .top) {
            // 親に座標を渡す
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollAmountPreferenceKey.self,
                                value: [geometry.frame(in: .global).minY])
            }

            list
        }
    }

    var list: some View {
        VStack {
            ForEach(1..<100) {
                Text("\($0) 行目").font(.title)
            }
        }
    }

    var header: some View {
        ZStack {
            Color.black
        }
        .frame(height: 100)
        .opacity(self.viewModel.bottomOpacity)
    }

    var bottom: some View {
        ZStack {
            Color.black
        }
        .frame(height: 100)
        .opacity(self.viewModel.bottomOpacity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
