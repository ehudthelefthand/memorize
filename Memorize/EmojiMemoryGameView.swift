//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Peerawat Poombua on 11/8/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding(.all)
    }

    @State private var dealt = Set<Int>()

    @Namespace private var   dealingCardNamespace

    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }

    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }

    private func dealingAnimation(_ card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (DrawingConstants.dealingDurationTotal / Double(game.cards.count))
        }
        return .easeInOut.delay(delay)
    }

    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }

    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .padding(2)
                    .matchedGeometryEffect(id: card.id, in: dealingCardNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card: card)
                        }
                    }
            }
        }
        .foregroundColor(DrawingConstants.color)
    }

    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingCardNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .foregroundColor(DrawingConstants.color)
        .frame(
            width: DrawingConstants.undealtCardWidth,
            height: DrawingConstants.undelatCardHeight
        )
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealingAnimation(card)) {
                    deal(card)
                }
            }
        }
    }

    var shuffle: some View {
        Button("shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }

    var restart: some View {
        Button("restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }

    private struct DrawingConstants {
        static let color: Color = .red
        static let cardRatio: CGFloat = 2/3
        static let undelatCardHeight: CGFloat = 90
        static let undealtCardWidth: CGFloat = undelatCardHeight * cardRatio
        static let dealingDurationTotal: Double = 3
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card

    @State var animatedBonusRemaining: Double = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(
                            startAngle: Angle(degrees: 0-90),
                            endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90)
                        )
                        .onAppear {
                            animatedBonusRemaining = card.bonusRemaining
                            withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                animatedBonusRemaining = 0
                            }
                        }
                    } else {
                        Pie(
                            startAngle: Angle(degrees: 0-90),
                            endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90)
                        )
                    }
                }
                .padding(5)
                .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                    .font(font(in: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }

    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }

    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
    }
}

struct EmojiGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards.first!)
        return Group {
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.light)
            EmojiMemoryGameView(game: game)
                .preferredColorScheme(.dark)
        }
    }
}
