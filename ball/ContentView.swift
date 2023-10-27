//
//  ContentView.swift
//  ball
//
//  Created by oiu on 27.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    private enum Identifier: String, CaseIterable {
        case inner
        case outer
    }
    
    @State
    private var offset: CGSize = .zero
    
    private var ball: some View {
        Circle()
            .foregroundColor(.white)
            .frame(width: 150, height: 150)
    }
    
    var body: some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.9, color: .white))
            context.addFilter(.blur(radius: 20))
            
            context.drawLayer { inner in
                for identifier in Identifier.allCases {
                    if let resolved = context.resolveSymbol(id: identifier) {
                        inner.draw(
                            resolved,
                            at: CGPoint(
                                x: size.width / 2,
                                y: size.height / 2
                            )
                        )
                    }
                }
            }
        } symbols: {
            ForEach(Identifier.allCases, id: \.self) { tag in
                ball
                    .tag(tag)
                    .offset(tag == .outer ? offset : .zero)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    offset = value.translation
                }
                .onEnded { _ in
                    withAnimation(
                        .interpolatingSpring(
                            mass: 1.5,
                            stiffness: 100,
                            damping: 17,
                            initialVelocity: 0
                        )
                    ) {
                        offset = .zero
                    }
                }
        )
        .background(Color.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
