//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Peerawat Poombua on 12/8/22.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card

    private static let emojis = [
        "🚗", "🚕", "🚙", "🚌", "🚎",
        "🏎", "🚓", "🚑", "🚒", "🚐",
        "🛻", "🚚", "🚛", "🚜", "🦽",
        "🛴", "🦼", "🚲", "🛵", "🏍",
        "🛺", "🚃", "🚋", "🚂", "✈️",
        "🚀", "🛸", "🚢", "🚁", "🛶"
    ]

    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairs: 4) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private var model = createMemoryGame()

    var cards: Array<Card> {
        model.cards
    }

    // MARK: - intent

    func choose(card: Card) {
        model.choose(card: card)
    }
}
