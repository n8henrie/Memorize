//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Nathan Henrie on 2021-02-14.
//

import SwiftUI

struct EmojiTheme {
    var name: String
    var emojis: [String]
    var numcards: Int?
    var color: Color
}

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    private static let themes = [
        EmojiTheme(name: "halloween", emojis: ["👻", "🎃", "🕷"], numcards: nil, color: .orange),
        EmojiTheme(name: "faces", emojis: ["😀", "😢", "😉"], numcards: 3, color: .purple),
        EmojiTheme(name: "animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐸"], numcards: 3, color: .blue),
        EmojiTheme(name: "balls", emojis: ["⚽️", "🏀", "⚾️", "🏈"], numcards: 4, color: .green),
        EmojiTheme(name: "fruits", emojis: ["🍎", "🍊", "🍒", "🍓"], numcards: 3, color: .red),
        EmojiTheme(name: "vehicles", emojis: ["✈️", "🚀", "🚁", "🚘", "🏍"], numcards: 5, color: .black),
    ]
    
    private static var themeIdx = Int.random(in: 0..<themes.count)
    
    func resetGame() {
        EmojiMemoryGame.themeIdx = Int.random(in: 0..<EmojiMemoryGame.themes.count)
        model = EmojiMemoryGame.createMemoryGame()
    }
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let theme = themes[themeIdx]
        
        let num_pairs = theme.numcards ?? Int.random(in: 2...5)
        return MemoryGame(numberOfPairsOfCards: num_pairs) { pairIndex in
            theme.emojis[pairIndex % theme.emojis.count]
        }
    }
    
    var theme: EmojiTheme {
        return EmojiMemoryGame.themes[EmojiMemoryGame.themeIdx]
    }
        
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }

    var score: Int {
        model.score
    }
    
    // MARK: Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
