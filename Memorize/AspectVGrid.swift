//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Peerawat Poombua on 29/6/23.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView

    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }

    var body: some View {
        GeometryReader { geomery in
            let width: CGFloat = widthThatFit(itemCount: items.count, size: geomery.size, itemAspectRatio: aspectRatio)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: width), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(2/3, contentMode: .fit)
                }
            }
        }
    }

    private func widthThatFit(itemCount: Int, size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount-1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
}

struct AspectVGrid_Previews: PreviewProvider {
    static var previews: some View {
        AspectVGrid(items: [
            EmojiMemoryGame.Card(id: 1, content: "A"),
            EmojiMemoryGame.Card(id: 2, content: "B"),
            EmojiMemoryGame.Card(id: 3, content: "C"),
            EmojiMemoryGame.Card(id: 4, content: "D"),
        ], aspectRatio: 2/3) { card in
            CardView(card: card)
        }
    }
}
