//
//  ContentView.swift
//  Memorize
//
//  Created by Nathan Henrie on 2021-02-14.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        NavigationView {
            VStack {
                AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                    CardView(card: card).onTapGesture {
                        withAnimation(.linear(duration: 0.75)) {
                            game.choose(card: card)
                        }
                    }.padding(4)
                })
                Text("score: \(game.score)")
            }
            .navigationBarTitle(
                Text(game.theme.name)
            )
            .toolbar {
                Button("New Game") {
                    withAnimation(.easeInOut){
                        game.resetGame()
                    }
                }
            }
        }.foregroundColor(game.theme.color)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }

    @State private var animatedBonusTimeRemaining: Double = 0

    private func startBonusTimeAnimation() {
        animatedBonusTimeRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusTimeRemaining = 0
        }
    }

    @ViewBuilder
    func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusTimeRemaining*360-90),
                            clockwise: true)
                            .onAppear {
                                startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90),
                            clockwise: true)
                    }
                }.padding(10).opacity(0.4)
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0)).animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)

            }.cardify(isFaceUp: card.isFaceUp)
                .transition(AnyTransition.scale)
        }
    }

    private func fontSize(for size: CGSize) -> CGFloat {
        0.65 * min(size.width, size.height)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game =  EmojiMemoryGame()
        //        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(game: game)
    }
}
