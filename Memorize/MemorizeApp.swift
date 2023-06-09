//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Peerawat Poombua on 11/8/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
