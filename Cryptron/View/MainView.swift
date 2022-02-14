//
//  TestScroll.swift
//  Cryptron
//
//  Created by chavin Panicharoen on 12/2/2565 BE.
//

//
//  P183_CircularList.swift
//  Fabula
//
//  Created by jasu on 2021/09/06.
//  Copyright (c) 2021 jasu All rights reserved.
//

// Warning: This code must be executed in Xcode 13.2 beta version or later. Memory issues may arise when running on Xcode 13.2 beta or lower versions.
// https://developer.apple.com/forums/thread/691415

import SwiftUI
import SDWebImageSwiftUI

public struct MainView: View {
    
    
    let rowSize: CGSize = CGSize(width: 350, height: 120)
    @State private var offsetValue: ScrollOffsetValue = ScrollOffsetValue()
    @EnvironmentObject private var vm:HomeViewModel
    @State private var generator = UINotificationFeedbackGenerator()
    
    public var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { proxyP in
                    ScrollView {
                        ZStack {
                            LazyVStack {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: proxyP.size.height * 0.5)
                                ForEach(vm.allCoins, id:\.id) { coin in
                                    GeometryReader { proxyC in
                                        let rect = proxyC.frame(in: .named("scroll"))
                                        let y = rect.minY
                                        let curveX = getCurveValue(y, proxyP.size.height) * rowSize.height - rowSize.height
                                        let opacity = getAlphaValue(y, proxyP.size.height)
    
                                        NavigationLink {
                                            DetailView(coin: coin)
                                                .edgesIgnoringSafeArea(.all)
                                        } label: {
                                            coinBadge(coin: coin)
                                                .opacity(opacity)
                                                .offset(x: curveX)
                                                .rotationEffect(.degrees(getRotateValue(y, proxyP.size.height) * 20), anchor: .leading)
                                        }
    
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .frame(width: rowSize.width, height: rowSize.height)
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: max(proxyP.size.height * 0.5, 1))
                            }
                            .offset(x: -proxyP.size.width * 0.2)
                            
                            OffsetInScrollView(named: "scroll")
                        }
                    }
                }
                .modifier(OffsetOutScrollModifier(offsetValue: $offsetValue, named: "scroll"))
                
                VStack {
                    HStack (spacing:20) {
                        searchBar
                        Spacer()
                        NavigationLink (destination: PortfolioView()) {
                            portfolioButton
                        }
                        refreshButton
                    }
                    .padding(.vertical,20)
                    .padding(.horizontal,32)
                    Spacer()
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
            
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.light)
    }
    
    private var searchBar : some View {
        ZStack {
            TextField("Search Coins", text: $vm.searchText)
                .disableAutocorrection(true)
                .padding(.leading,20)
                .font(.caption)
                .frame(width:150,height:50)
                .background(
                    ZStack {
                        Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                        RoundedRectangle(cornerRadius: 10,style: .continuous)
                            .foregroundColor(.white).blur(radius: 4)
                            .offset(x: 2, y: 2)
                        RoundedRectangle(cornerRadius: 10,style: .continuous)
                            .foregroundColor(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
                            .offset(x: 2, y: 2)
                            .padding(1).blur(radius: 2)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 20, x: -20, y: -20)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding()
                        .opacity(vm.searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.2)) {
                                UIApplication.shared.keyWindow?.endEditing(true)
                                vm.searchText = ""
                            }
                        }
                    ,alignment: .trailing)
        }
    }
    
    
    private var refreshButton : some View {
        VStack {
                VStack {
                    Button {
                        vm.reloadCoin()
                        generator.notificationOccurred(.success)
                    } label: {
                        Image(systemName: "repeat")
                            .font(.body)
                            .foregroundColor(Color(.systemGray4))
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(
                                ZStack {
                                    Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                                        .foregroundColor(.white).blur(radius: 4)
                                        .offset(x: 2, y: 2)
                                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                                        .foregroundColor(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
                                        .offset(x: 2, y: 2)
                                        .padding(1).blur(radius: 2)
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 20, x: -20, y: -20)
                            
                    }
                }
        }
    }
    
    private var portfolioButton : some View {
        VStack {
                VStack {
                        Image(systemName: "book")
                            .font(.body)
                            .foregroundColor(Color(.systemGray4))
                            .frame(width: 50, height: 50, alignment: .center)
                            .background(
                                ZStack {
                                    Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                                        .foregroundColor(.white).blur(radius: 4)
                                        .offset(x: 2, y: 2)
                                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                                        .foregroundColor(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
                                        .offset(x: 2, y: 2)
                                        .padding(1).blur(radius: 2)
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 20, x: -20, y: -20)
                            
                }
        }
    }
    
    
    private func coinBadge(coin:CoinModel) -> some View {
        HStack {
            WebImage(url: URL(string: coin.image ))
                .resizable()
                .frame(width: 40, height: 40, alignment: .center)

            Text("\(coin.name)")
                .font(.caption.bold())
                .frame(width:70)
                .multilineTextAlignment(.center)
            VStack (alignment:.leading) {
                Text("\((coin.currentPrice.asCurrencyWith6Decimals())) USD")
                    .font(.footnote)
                Text("\(coin.priceChangePercentage24H?.asPercentString() ?? "0.0")")
                    .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.green : Color.red)
                    .font(.caption)
            }
            .padding(.leading,30)
        }
        .frame(width: rowSize.width, height: rowSize.height)
        .clipShape(Capsule())
        .background(
            ZStack {
                Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                RoundedRectangle(cornerRadius: 10,style: .continuous)
                    .foregroundColor(.white).blur(radius: 4)
                    .offset(x: 2, y: 2)
                RoundedRectangle(cornerRadius: 10,style: .continuous)
                    .foregroundColor(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
                    .offset(x: 2, y: 2)
                    .padding(1).blur(radius: 2)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 20, x: -20, y: -20)
    }
    
    private func getAlphaValue(_ current: Double, _ total: Double) -> CGFloat {
        let x = Double(current) / Double(total)
        let y = (sin(-1.1 * (.pi * x) - .pi / 1))
        return CGFloat(y)
    }
    
    private func getCurveValue(_ current: Double, _ total: Double) -> CGFloat {
        let x = Double(current) / Double(total)
        let y = (sin(-1 * .pi * x - .pi) + 0.5) / 2.0
        return 2 * CGFloat(y)
    }
    
    private func getRotateValue(_ current: Double, _ total: Double) -> CGFloat {
        let x = Double(current) / Double(total)
        let y = (sin(.pi * x - (.pi / 2.0))) / 2.0
        return 2 * CGFloat(y)
    }
}

fileprivate
struct ScrollOffsetValue: Equatable {
    var x: CGFloat = 0
    var y: CGFloat = 0
    var contentSize: CGSize = .zero
    
}

fileprivate
struct ScrollOffsetKey: PreferenceKey {
    typealias Value = ScrollOffsetValue
    static var defaultValue = ScrollOffsetValue()
    static func reduce(value: inout Value, nextValue: () -> Value) {
        let newValue = nextValue()
        value.x += newValue.x
        value.y += newValue.y
        value.contentSize = newValue.contentSize
    }
}

fileprivate
struct OffsetInScrollView: View {
    let named: String
    var body: some View {
        GeometryReader { proxy in
            let offsetValue = ScrollOffsetValue(x: proxy.frame(in: .named(named)).minX,
                                                y: proxy.frame(in: .named(named)).minY,
                                                contentSize: proxy.size)
            Color.clear.preference(key: ScrollOffsetKey.self, value: offsetValue)
        }
    }
}

fileprivate
struct OffsetOutScrollModifier: ViewModifier {
    
    @Binding var offsetValue: ScrollOffsetValue
    let named: String
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .coordinateSpace(name: named)
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    offsetValue = value
                    offsetValue.contentSize = CGSize(width: offsetValue.contentSize.width - proxy.size.width, height: offsetValue.contentSize.height - proxy.size.height)
                }
        }
    }
}


struct TestScroll_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(HomeViewModel())
    }
}
