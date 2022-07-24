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

        GeometryReader { geometry in

            ZStack(alignment: .top ) {
                
                header
                    .zIndex(.infinity)

                ZStack(alignment: .bottom) {
                    ScrollView() {
                        scrollContents
                            .padding(.top, viewModel.topScrollSpace)
                    }
                    
                    VStack {
                        ZStack {

                        Circle()
                            .foregroundColor(Color.white)
                            .frame(width: 60, height: 60)
                            .shadow(radius: 2)


                            Image(systemName: "pencil")
                                .resizable()
                                .foregroundColor(Color.red)
                                .frame(width: 30, height: 30)
                                .frame(width: 60, height: 60)

                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding([.bottom, .trailing], 30)


                        bottom
                    }
                    .offset(y: viewModel.isShowBottomSheet ? 0 : 100)
                    .animation(.default, value: viewModel.isShowBottomSheet)
                }
            }.onAppear() {
                viewModel.safeAreaTop = geometry.safeAreaInsets.top
            }
        }
        .ignoresSafeArea(edges: [.bottom])
        .onPreferenceChange(ScrollAmountPreferenceKey.self) { value in
            viewModel.scrollEventHandler(value: value)
        }
        .onAppear {
//            self.task = self.viewModel.$prevScrollOrientation.receive(on: DispatchQueue.main)
//                .sink { (value) in
//                    switch value {
//                    case .down:
//                        print("↓")
//                    case .up:
//                        print("↑")
//                    }
//                }
        }
    }

    var scrollContents: some View {

        ZStack(alignment: .top) {
            // 親に座標を渡す
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollAmountPreferenceKey.self,
                                value: geometry.frame(in: .global).minY)
                    .onAppear {
                        print(geometry.safeAreaInsets.top)
                    }
            }

            list
        }
    }

    var list: some View {
        VStack(spacing: 0) {
            ForEach(1..<100) {
                Text("\($0) 行目").font(.title)
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
        }
        
    }

    var header: some View {

        Text("メールを検索")
            .foregroundColor(Color.gray)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color.white)
            .cornerRadius(5)
            .shadow(radius: 2)
            .padding(.horizontal, 10)
            .offset(y: viewModel.isShowHeader ? 0 : -100)
            .animation(.default, value: viewModel.isShowHeader)
    }

    var bottom: some View {
        ZStack {
            Color.white
            HStack {
                Image(systemName: "pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .frame(maxWidth: .infinity)

                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .frame(height: 100)
        .shadow(radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
