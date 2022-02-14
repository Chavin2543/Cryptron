//
//  CoinLogoView.swift
//  Cryptron
//
//  Created by chavin Panicharoen on 13/2/2565 BE.
//

import SwiftUI
import SDWebImageSwiftUI

struct CoinLogoView: View {
    let coin:CoinModel
    var body: some View {
        VStack {
            WebImage(url: URL(string: coin.image))
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60, alignment: .center)
            Text(coin.symbol.uppercased())
        }
        .frame(width: 100, height: 100, alignment: .center)
        .padding()
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
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinLogoView(coin: dev.coin)
    }
}
