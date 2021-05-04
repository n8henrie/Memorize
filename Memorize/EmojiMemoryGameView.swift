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
        NavigationView {
            VStack {
                Grid(viewModel.cards) { card in
                    CardView(card: card).onTapGesture {
                        viewModel.choose(card: card)
                    }
                    .padding(10)
                }
                Text("score: \(viewModel.score)")
            }
            .padding()
            .foregroundColor(viewModel.theme.color)
            .navigationBarTitle(viewModel.theme.name)
            .toolbar {
                Button("New Game") {
                    viewModel.resetGame()
                }
            }
        }
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
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius).fill()
                    }
                }
            }.font(Font.system(size: fontSize(for: size))
            )
        }
        
        private func fontSize(for size: CGSize) -> CGFloat {
            0.75 * min(size.width, size.height)
        }
        
        // MARK: - Drawing Constants
        
        private let cornerRadius: CGFloat = 10
        private let edgeLineWidth: CGFloat = 3
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
