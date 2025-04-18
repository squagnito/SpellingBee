//
//  HexagonView.swift
//  SpellingBee
//
//  Created by Aaron Medina on 4/16/25.
//

import SwiftUI

struct HexagonView: View {
    let letter: String
    let isCenter: Bool
    
    var body: some View {
        ZStack {
            Polygon(sides: 6)
                .fill(isCenter ? Color.yellow : Color.gray.opacity(0.2))
                .frame(width: 70, height: 70)        
            
            Text(letter.uppercased())
                .font(.system(size: 24, weight: .bold))
        }
    }
}

struct Polygon: Shape {
    var sides: Int
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        
        var path = Path()
        let angle = Double.pi * 2 / Double(sides)
        
        for i in 0..<sides {
            let currentAngle = angle * Double(i) - Double.pi / 2
            let x = center.x + radius * cos(currentAngle)
            let y = center.y + radius * sin(currentAngle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    HexagonView(letter: "i", isCenter: true)
}
