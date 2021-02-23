//
//  ContentView.swift
//  Memorize
//
//  Created by Nathan Henrie on 2021-02-14.
//

import SwiftUI

struct ContentView: View {
    var viewModel: EmojiMemoryGame
    var body: some View {
        let hstack = HStack {
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    viewModel.choose(card: card)
                }
            }
        }
        .padding()
        .foregroundColor(Color.orange)
        
        if viewModel.cards.count > 4 {
            hstack.font(Font.title)
        } else {
            hstack.font(Font.largeTitle)
        }
        
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
            if card.isFaceUp {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(Color.white)
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 3)
                    Text(card.content)
                }.aspectRatio((2/3), contentMode: .fit)
            } else {
                RoundedRectangle(cornerRadius: 10).fill().aspectRatio((2/3), contentMode: .fit)
            }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
