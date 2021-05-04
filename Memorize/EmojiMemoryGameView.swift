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

        @ViewBuilder
        func body(for size: CGSize) -> some View {
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90),
                        clockwise: true).padding(10).opacity(0.4)
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: size))
                        )
                }.cardify(isFaceUp: card.isFaceUp)
            }
        }
        
        private func fontSize(for size: CGSize) -> CGFloat {
            0.65 * min(size.width, size.height)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game =  EmojiMemoryGame()
        //        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel:game)
    }
}
