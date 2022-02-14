//
//  PortfolioCoins.swift
//  Cryptron
//
//  Created by chavin Panicharoen on 13/2/2565 BE.
//

import SwiftUI
import SDWebImageSwiftUI

struct PortfolioCoinsView: View {
    
    var coin:CoinModel
    @State var function: () -> Void
    
    var body: some View {
        GeometryReader  { proxy in
            ZStack {
                Rectangle()
                    .frame(height:300)
                    .foregroundColor(.clear)
                    .background(
                        ZStack {
                            Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1))
                            RoundedRectangle(cornerRadius: 10,style: .continuous)
                                .foregroundColor(.white).blur(radius: 4)
                                .offset(x: 2, y: 2)
                            RoundedRectangle(cornerRadius: 10,style: .continuous)
                                .foregroundColor(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
                                .offset(x: 2, y: 2)
                                .padding(4).blur(radius: 2)
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 20, y: 20)
                .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 20, x: -20, y: -20)
                
                VStack(spacing:20){
                    HStack(alignment:.center) {
                        WebImage(url: URL(string: coin.image))
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                        Text("\(coin.name):")
                            .font(.title)
                            .fontWeight(.light)
                        Text("\(coin.currentHoldings?.with2Decimal() ?? "")")
                            .font(.body.bold())
                        Spacer()
                        Button {
                            function()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red.opacity(0.7))
                                .frame(width: 50, height: 50, alignment: .center)
                        }
                    }
                    HStack {
                        Text("Price added : \((coin.entryPrice ?? 0.0).asCurrencyWith6Decimals())")
                            .font(.caption)
                        Spacer()
                    }
                    HStack {
                        Text("Current Price : \(coin.currentPrice.asCurrencyWith6Decimals())")
                            .font(.caption)
                        Spacer()
                    }
                    HStack {
                        Text("Current Amount Holdings : \(coin.currentHoldingsValue.asCurrencyWith2Decimals() )")
                            .font(.caption)
                        Spacer()
                    }
                    HStack {
                        Text("Entry Amount Holdings : \(coin.initialHoldingsValue.asCurrencyWith2Decimals())")
                            .font(.caption)
                        Spacer()
                    }
                    HStack {
                        Text("Profit: \(coin.profit.asCurrencyWith2Decimals())")
                            .foregroundColor(coin.profit > 0 ? .green : .red)
                            .bold()
                            .font(.footnote)
                        Text("(\(coin.profitPercentage.asPercentString() ))")
                            .foregroundColor(coin.profit > 0 ? .green : .red)
                            .bold()
                            .font(.footnote)
                        Spacer()
                    }
                }
                .overlay(
                    Text("\(coin.profitPercentage.asPercentString())")
                        .font(.body.bold())
                        .foregroundColor(coin.profit > 0 ? .green : .red)
                    
                    ,alignment: .bottomTrailing
                    
                )
                .frame(width:proxy.size.width > 64 ? proxy.size.width-64 : 0,height:300)
            }
        }
    }
}

struct PortfolioCoins_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioCoinsView(coin: dev.coin) {
            print("Hello")
        }
    }
}
