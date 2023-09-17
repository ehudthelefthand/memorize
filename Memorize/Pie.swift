//
//  Pie.swift
//  Memorize
//
//  Created by Peerawat Poombua on 29/6/23.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false

    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        var p = Path()

        p.move(to: center)
        p.addLine(
            to: .init(
                x: center.x + radius * CGFloat(cos(startAngle.radians)),
                y: center.y + radius * CGFloat(sin(startAngle.radians))
            )
        )
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        p.addLine(to: center)

        return p
    }
}
