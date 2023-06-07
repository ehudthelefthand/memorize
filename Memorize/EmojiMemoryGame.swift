//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Peerawat Poombua on 12/8/22.
//

import Foundation

class EmojiMemoryGame: ObservableObject {

    static let emojis = [
        "🚗", "🚕", "🚙", "🚌", "🚎",
        "🏎", "🚓", "🚑", "🚒", "🚐",
        "🛻", "🚚", "🚛", "🚜", "🦽",
        "🛴", "🦼", "🚲", "🛵", "🏍",
        "🛺", "🚃", "🚋", "🚂", "✈️",
        "🚀", "🛸", "🚢", "🚁", "🛶"
    ]

    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairs: 4) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private var model = createMemoryGame()

    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }

    // MARK: - intent

    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
