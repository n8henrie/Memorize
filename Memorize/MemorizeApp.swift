//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Nathan Henrie on 2021-02-14.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
}
