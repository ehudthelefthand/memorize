//
//  Cardify.swift
//  Memorize
//
//  Created by Peerawat Poombua on 12/7/23.
//

import SwiftUI

struct Cardify: ViewModifier {

    var isFaceUp: Bool

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        if isFaceUp {
            shape.fill(.white)
            shape.strokeBorder(lineWidth: DrawingConstants.cardBorderWidth)
        } else {
            shape.fill()
        }
        content
            .opacity(isFaceUp ? 1 : 0)
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
