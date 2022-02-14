//
//  PortfolioView.swift
//  Cryptron
//
//  Created by chavin Panicharoen on 13/2/2565 BE.
//

import SwiftUI

struct PortfolioView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var vm:HomeViewModel
    @State private var selectedCoin:CoinModel? = nil
    @State private var quantityText:String = ""
    @State private var entryValueText:String = ""

    
    var body: some View {
                GeometryReader { proxy in
                ZStack {
                    ScrollView(showsIndicators:false) {
                        VStack {
                            HStack {
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.largeTitle)
                                        .foregroundColor(Color("TextColor"))
                                }
                                Text("Portfolio")
                                    .font(.largeTitle)
                                    .foregroundColor(Color("TextColor"))
                                   
                                Spacer()
                                if selectedCoin != nil {
                                    Button {
                                        saveButtonPressed()
                                    } label: {
                                        HStack {
                                            Image(systemName: "checkmark")
                                                .font(.body.bold())
                                            Text("Save")
                                                .font(.body.bold())
                                        }
                                        .foregroundColor(.green)
                                    }
                                }
                            }
                            .padding(32)
                            ScrollView(.horizontal,showsIndicators: false) {
                                LazyHStack (spacing:20) {
                                    ForEach(vm.allCoins) { coin in
                                        CoinLogoView(coin: coin)
                                            .onTapGesture {
                                                withAnimation {
                                                        selectedCoin = coin
                                                }
                                            }
                                            .foregroundColor(selectedCoin?.id == coin.id ? .green : .black)
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(selectedCoin?.id == coin.id ? .green : .clear,lineWidth: 4)
                                            )
                                    }
                                }
                            }
                            
                            if selectedCoin != nil {
                                VStack(spacing:20) {
                                    VStack (spacing:20) {
                                        Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                                        Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                                            .frame(width:100)
                                            .multilineTextAlignment(.leading)
                                    }
                                    Divider()
                                    VStack (spacing:20) {
                                        Text("Amount in your portfolio")
                                        TextField("Ex. 1.4", text: $quantityText)
                                            .multilineTextAlignment(.center)
                                    }
                                    Divider()
                                    VStack (spacing:20) {
                                        Text("Entry Price")
                                        TextField("Ex. 140 USD", text: $entryValueText)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .frame(width:proxy.size.width-64)
                            }
                            
                            ScrollView(showsIndicators:false) {
                                LazyVStack (spacing:20) {
                                    ForEach(vm.portFolioCoins, id:\.id) { coin in
                                        PortfolioCoinsView(coin: coin, function: {
                                            deleteCoin(coin: coin)
                                        })
                                            .frame(height:300)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.top,40)
                            Spacer()
                        }
                        .frame(width:proxy.size.width-32)
                    }
                }
                .frame(maxWidth:.infinity,maxHeight: .infinity)
                .background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)))
                .navigationBarHidden(true)
        }
    }
    
    private func saveButtonPressed() {
        
        guard let coin = selectedCoin,
              let amount = Double(quantityText),
              let entryPrice = Double(entryValueText)
            else {return}
        
        vm.updatePortfolio(coin: coin, amount: amount, entryPrice: entryPrice)
        
        withAnimation(.easeIn) {
            selectedCoin = nil
        }
        
        
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
    }
    
    private func updateSelectedCoin(coin:CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portFolioCoins.first(where: {$0.id == coin.id}) {
            let amount = portfolioCoin.currentHoldings
            quantityText = "\(amount ?? 0.0)"
        } else {
            quantityText = ""
        }
    }
    
    private func deleteCoin(coin:CoinModel) {
        vm.updatePortfolio(coin: coin, amount: 0, entryPrice: 0)
        
        withAnimation(.easeIn) {
            selectedCoin = nil
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(HomeViewModel())
    }
}
