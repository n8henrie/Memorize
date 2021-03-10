//
//  ContentView.swift
//  Memorize
//
//  Created by Nathan Henrie on 2021-02-14.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        Grid(viewModel.cards) { card in
            CardView(card: card).onTapGesture {
                viewModel.choose(card: card)
            }
            .padding(10)
        }
        .padding()
        .foregroundColor(Color.orange)

    }
    
    struct CardView: View {
        var card: MemoryGame<String>.Card
        
        var body: some View {
            GeometryReader { geometry in
                self.body(for: geometry.size)
            }
        }
        
        func body(for size: CGSize) -> some View {
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
            }.font(Font.system(size: fontSize(for: size))
            )
        }
        
        func fontSize(for size: CGSize) -> CGFloat {
            0.75 * min(size.width, size.height)
        }
        
        // MARK: - Drawing Constants
        
        let cornerRadius: CGFloat = 10
        let edgeLineWidth: CGFloat = 3
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
