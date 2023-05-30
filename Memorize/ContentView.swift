//
//  ContentView.swift
//  Memorize
//
//  Created by Peerawat Poombua on 11/8/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: EmojiMemoryGame

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))] ) {
                    ForEach(game.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                game.choose(card: card)
                            }
                    }
                }
            }
            .padding(.all)
            .font(.largeTitle)
        }
        .padding(.all)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 16)
        ZStack {
            if card.isFadeUp {
                shape.fill(.white)
                shape.strokeBorder(lineWidth: 4)
                Text(card.content).font(.largeTitle)
            } else {
                shape.fill(.red)
            }
        }
        .foregroundColor(.red)
        .opacity(card.isMatched ? 0 : 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(game: game)
            .preferredColorScheme(.light)
        ContentView(game: game)
            .preferredColorScheme(.dark)
    }
}
