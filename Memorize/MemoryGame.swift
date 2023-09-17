//
//  MemoryGame.swift
//  Memorize
//
//  Created by Peerawat Poombua on 12/8/22.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {

    private(set) var cards: Array<Card>

    private var indexOfOneAndOnlyOneFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }

    init(numberOfPairs: Int, createCard: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairs {
            let content = createCard(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
        cards.shuffle()
    }

    mutating func choose(card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }),
           !cards[index].isFaceUp,
           !cards[index].isMatched {
            if let indexOfPotentiallyMatchCard = indexOfOneAndOnlyOneFaceUpCard {
                if cards[indexOfPotentiallyMatchCard].content == cards[index].content {
                    cards[indexOfPotentiallyMatchCard].isMatched = true
                    cards[index].isMatched = true
                }
            } else {
                indexOfOneAndOnlyOneFaceUpCard = index
            }
            cards[index].isFaceUp = true
        }
    }

    mutating func shuffle() {
        cards.shuffle()
    }

    struct Card: Identifiable {
        let id: Int
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startBonusTime()
                } else {
                    stopBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopBonusTime()
            }
        }
        let content: CardContent

        // MARK: - Bonus time

        private mutating func startBonusTime() {
            if isConsumingBonusTime, lastFaceUpTime == nil {
                lastFaceUpTime = Date()
            }
        }

        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }

        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }

        var bonusTimeLimit: TimeInterval = 6

        var faceUpTime: TimeInterval {
            if let lastFaceUpTime = lastFaceUpTime {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpTime)
            } else {
                return pastFaceUpTime
            }
        }

        var lastFaceUpTime: Date?

        var pastFaceUpTime: TimeInterval = 0

        private mutating func stopBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpTime = nil
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
