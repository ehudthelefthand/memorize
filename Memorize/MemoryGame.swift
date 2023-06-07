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
        get { cards.indices.filter { cards[$0].isFadeUp }.oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFadeUp = ($0 == newValue) } }
    }

    init(numberOfPairs: Int, createCard: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairs {
            let content = createCard(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
    }

    mutating func choose(card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }),
           !cards[index].isFadeUp,
           !cards[index].isMatched {
            if let indexOfPotentiallyMatchCard = indexOfOneAndOnlyOneFaceUpCard {
                if cards[indexOfPotentiallyMatchCard].content == cards[index].content {
                    cards[indexOfPotentiallyMatchCard].isMatched = true
                    cards[index].isMatched = true
                }
            } else {
                indexOfOneAndOnlyOneFaceUpCard = index
            }
            cards[index].isFadeUp = true
        }
    }

    struct Card: Identifiable {
        let id: Int
        var isFadeUp = false
        var isMatched = false
        let content: CardContent
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
