//
//  MemoryGame.swift
//  Memorize
//
//  Created by Nathan Henrie on 2021-02-14.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    mutating func choose(card: Card) {
        let idx = cards.firstIndex(matching: card)
        self.cards[idx].isFaceUp = !self.cards[idx].isFaceUp
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for idx in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(idx)
            cards.append(Card(content: content, id: idx*2))
            cards.append(Card(content: content, id: idx*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
