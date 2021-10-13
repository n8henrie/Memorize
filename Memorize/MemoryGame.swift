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
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }

        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        
        var content: CardContent
        var id: Int
        var seen: Bool = false

        // MARK: - Bonus Time

        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up

        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }

    }
}
