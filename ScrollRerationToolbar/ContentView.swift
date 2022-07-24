//
//  ContentView.swift
//  ScrollRerationToolbar
//
//  Created by 名前なし on 2022/07/23.
//

import SwiftUI
import Combine

struct ContentView: View {

    @ObservedObject var viewModel = ScrollViewModel()
    @State private var count = CGFloat(0)

    @State private var scollAmountHistroyCount: Int = 0
    @State private var alertScrollAmount: Int = 50
    @State var task: AnyCancellable? = nil

    struct ScrollAmountPreferenceKey: PreferenceKey {

        // 子から親に渡す値の型
        typealias Value = CGFloat

        // PreferenceKeyは必ず実装
        static var defaultValue: Value = CGFloat.zero

        // PreferenceKeyは必ず実装
        // inout -> 参照　nextValue -> 親に渡す値
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
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


            viewModel.getScrollVector(value: value)

        
            self.scollAmountHistroyCount += 1

            if self.scollAmountHistroyCount >= alertScrollAmount {

                if value < 130 && value >= 0{
                    return
                }

                if value >= 50 {
                    self.viewModel.isShowBottomMenu = true
                }

                self.viewModel.offsetY = value

                self.scollAmountHistroyCount = 0
            }
        }
        .onAppear {
            self.task = self.viewModel.$currentVector.receive(on: DispatchQueue.main)
                .sink { (value) in
                    print(value ?? "nil")
                }
        }
    }

    var scrollContents: some View {

        ZStack(alignment: .top) {
            // 親に座標を渡す
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollAmountPreferenceKey.self,
                                value: geometry.frame(in: .global).minY)
            }

            list
        }
    }

    var list: some View {
        VStack(spacing: 0) {
            ForEach(1..<100) {
                Text("\($0) 行目").font(.title)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .border(Color.black)
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
