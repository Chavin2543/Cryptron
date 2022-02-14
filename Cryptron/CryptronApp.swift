//
//  CryptronApp.swift
//  Cryptron
//
//  Created by chavin Panicharoen on 12/2/2565 BE.
//

import SwiftUI

@main
struct CryptronApp: App {
    @StateObject private var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(vm)
        }
    }
}
