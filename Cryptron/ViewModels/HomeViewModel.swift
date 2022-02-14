//
//  HomeViewModel.swift
//  Cryptron
//
//  Created by chavin Panicharoen on 12/2/2565 BE.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portFolioCoins: [CoinModel] = []
    @Published var searchText:String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let dataService = CoinDataService()
    private let portfolioDataService = PortfolioDataService()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
    
        //update AllCoins
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        //updatePortfolio Coins
        dataService.$allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels,portFolioEntities) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portFolioEntities.first(where: {$0.coinID == coin.id}) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount, entry: entity.entryPrice)
                    }
            }
            .sink { [weak self] returnedEntityCoins in
                self?.portFolioCoins = returnedEntityCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin:CoinModel,amount:Double,entryPrice:Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount, entryPrice: entryPrice)
    }
    
    private func filterCoins(text:String,targetCoin:[CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return targetCoin
        }
        
        let lowercaseText = text.lowercased()
        return targetCoin.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercaseText) ||
            coin.symbol.lowercased().contains(lowercaseText) ||
            coin.id.lowercased().contains(lowercaseText)
        }
    }
    
    func reloadCoin() {
        print("reloading Coin")
        dataService.getCoins()
        addSubscribers()
    }
}
