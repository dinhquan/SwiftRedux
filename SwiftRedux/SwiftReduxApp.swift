//
//  SwiftReduxApp.swift
//  SwiftRedux
//
//  Created by Quan on 11/11/2021.
//

import SwiftUI

@main
struct SwiftReduxApp: App {
    init() {
        registerDependencies()
        StoreContainer.shared.initializeStore()
    }
    
    var body: some Scene {
        WindowGroup {
            ArticleListView(viewModel: .init())
        }
    }
    
    private func registerDependencies() {
        Resolver.register(DefaultArticleService() as ArticleService)
    }
}
