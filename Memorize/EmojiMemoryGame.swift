//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nathan Henrie on 2021-02-14.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃", "🕷"]
        let num_pairs = Int.random(in: 2...5)
        return MemoryGame<String>(numberOfPairsOfCards: num_pairs) { pairIndex in
            emojis[pairIndex % emojis.count]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
