//
//  Cardify.swift
//  Memorize
//
//  Created by Peerawat Poombua on 12/7/23.
//

import SwiftUI

struct Cardify: AnimatableModifier {

    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 180 : 0
    }

    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    var rotation: Double // in degrees

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation > 90 {
                shape.fill(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.cardBorderWidth)
            } else {
                shape.fill()
            }
            content
                .opacity(rotation > 90 ? 1 : 0)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
    }

    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 12
        static let cardBorderWidth: CGFloat = 4
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
