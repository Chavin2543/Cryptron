//
//  PortfolioDataService.swift
//  Cryptron
//
//  Created by chavin Panicharoen on 13/2/2565 BE.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container:NSPersistentContainer
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "Portfolio")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error Loading CoreData \(error)")
            }
        }
        getPortfolio()
    }
    
    //MARK:PUBLIC
    
    func updatePortfolio(coin:CoinModel,amount:Double,entryPrice:Double) {
        
        if let entity = savedEntities.first(where: { $0.coinID == coin.id}) {
            
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount, entryPrice: entryPrice)
        }
    }
    
    //MARK:PRIVATE
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching Portfolio Entity. \(error)")
        }
    }
    
    private func add(coin:CoinModel,amount:Double,entryPrice:Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.amount = amount
        entity.coinID = coin.id
        entity.entryPrice = entryPrice
        applyChanges()
    }
    
    private func update(entity:PortfolioEntity, amount:Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity:PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error Saving to CoreData \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
}
