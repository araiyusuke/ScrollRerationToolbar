//
//  ContentView.swift
//  ScrollRerationToolbar
//
//  Created by 名前なし on 2022/07/23.
//

import SwiftUI
import Combine

struct ContentView: View {

    @StateObject var viewModel = ScrollViewModel()
    @State private var count = CGFloat(0)
    @State private var scollAmountHistroyCount: Int = 0
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

            header

            ZStack(alignment: .bottom) {
                ScrollView() {
                    scrollContents
                }
                bottom
                    .offset(y: viewModel.bottomOpacity == 1 ? -0 : 100)
                    .animation(.default, value: viewModel.bottomOpacity)
            }
        }
        .ignoresSafeArea(edges: [.top, .bottom])
        .onPreferenceChange(ScrollAmountPreferenceKey.self) { value in
            viewModel.scrollEventHandler(value: value)
        }
        .onAppear {
            self.task = self.viewModel.$prevScrollVector.receive(on: DispatchQueue.main)
                .sink { (value) in
                    switch value {
                    case .down:
                        print("↓に切り替わる")
                    case .up:
                        print("上に切り替わる")
                    case .none:
                        print("開始")
                    }
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
        VStack {
            Text("メールを検索")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, maxHeight: 30)
                .padding()
                .background(Color.black)
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .cornerRadius(4)
        .offset(y: viewModel.headerOpacity == 1 ? 0 : -100)
        .animation(.default, value: viewModel.headerOpacity)

    }

    var bottom: some View {
        ZStack {
            Color.black
        }
        .frame(height: 100)
//        .opacity(self.viewModel.bottomOpacity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
