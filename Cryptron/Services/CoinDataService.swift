//
//  CoinDataService.swift
//  Cryptron
//
//  Created by chavin Panicharoen on 12/2/2565 BE.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins:[CoinModel] = []
    var coinSubscription:AnyCancellable?
    
    init() {
        getCoins()
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            print("Getting coin with typical dataTask")
//            self.getCoinsBasic()
            
        }
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case.finished:
                    print("Succeed")
                case.failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnedValue in
                self?.allCoins = returnedValue
                self?.coinSubscription?.cancel()
            }

    }
    
    func getCoinsBasic() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return}
        
        URLSession.shared.dataTask(with: url) { [weak self](data, response, error) in
            
            guard let data = data else {
                print("Error Retrieving data")
                return
            }
            
            guard error == nil else {
                print("Error :\(error)")
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("Invalid Response")
                return
            }
            
            let decoder = JSONDecoder()
            let extractedData = try? decoder.decode([CoinModel].self, from: data)
            
            DispatchQueue.main.async{ [weak self] in
                print(extractedData)
            }
        }
        .resume()
        
    }
    
}
