//
//  DetailView.swift
//  Cryptron
//
//  Created by chavin Panicharoen on 12/2/2565 BE.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    @State var coin:CoinModel
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack (spacing:20) {
                    VStack (alignment:.leading) {
                        WebImage(url: URL(string: coin.image ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width:proxy.size.width,height:proxy.size.height * 0.3)
                        .clipped()
                        Text(coin.name)
                            .font(.largeTitle.bold())
                            .padding(32)
                           
                    }
                    ChartView(coin: coin)
                    VStack (spacing:20){
                        HStack {
                            Text("Overview")
                                .font(.title.bold())
                            Spacer()
                        }
                        Divider()
                        HStack {
                            VStack (alignment:.leading, spacing: 10) {
                                Text("Current Price")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
                                    .font(.body.bold())
                            }
                            Spacer()
                            VStack (alignment:.leading, spacing: 10) {
                                Text("Market Cap")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(coin.marketCap?.formattedWithAbbreviations() ?? "")")
                                    .font(.body.bold())
                            }
                            Spacer()
                        }
                        HStack {
                            VStack (alignment:.leading, spacing: 10) {
                                Text("Rank")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(coin.rank)")
                                    .font(.body.bold())
                            }
                            Spacer()
                            VStack (alignment:.leading, spacing: 10) {
                                Text("Volume")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(coin.totalVolume?.formattedWithAbbreviations() ?? "")")
                                    .font(.body.bold())
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .frame(width:proxy.size.width-64)
            }
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
        }
        .ignoresSafeArea()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
