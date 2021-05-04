//
//  MemoryGame.swift
//  Memorize
//
//  Created by Nathan Henrie on 2021-02-14.
//

import Foundation

struct MemoryGame<CardContent: Equatable> {
    private(set) var cards: Array<Card>
    var score: Int

    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        set {
            for idx in cards.indices {
                cards[idx].isFaceUp = idx == newValue
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for idx in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(idx)
            cards.append(Card(content: content, id: idx*2))
            cards.append(Card(content: content, id: idx*2+1))
        }
        cards.shuffle()
        score = 0
    }
    
    mutating func choose(card: Card) {
        if let idx = cards.firstIndex(matching: card), !cards[idx].isFaceUp, !cards[idx].isMatched {
            if let potentialMatchIdx = indexOfOneAndOnlyFaceUpCard {
                if cards[idx].content == cards[potentialMatchIdx].content {
                    for i in [idx, potentialMatchIdx] {
                        cards[i].isMatched = true
                    }
                    score += 2
                } else {
                    for i in [idx, potentialMatchIdx] {
                        if cards[i].seen {
                            score -= 1
                        }
                        cards[i].seen = true
                    }
                }
                self.cards[idx].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = idx
            }
        }
    }
    
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        var seen: Bool = false
    }
}
