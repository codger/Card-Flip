//
//  ContentView.swift
//  Card Flip
//
//  Created by John James Retina on 3/29/20.
//  Copyright © 2020 John James. All rights reserved.
//

import SwiftUI

let suits = ["Hearts", "Clubs", "Diamonds", "Spades", "Joker"]
let rankNames = ["Ace","2","3","4","5","6","7","8","9","10","Jack","Queen","King"]

let ranks =   [ 1,2,3,4,5, 6,7,8,9,10, 11,12,13]
let backOfCard = 999
let joker = 996
let aSpacer = 998

struct ContentView: View {
  @State var card = 45.0
  @State var flipAngle = Double.pi / 1.0
  @State var rotateAngle = 0.0
  @State var deck = [Int]()
  @State var discards = [Int]()
  @State var hand = [Int]()
  @State var deckPosition = CGPoint()
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Color.clear
        HStack{
          ZStack {
            ForEach(0 ..< self.deck.count, id: \.self) { number in
              CardImage(cardID: number)
            }
          }.padding(.trailing, 50)
          ZStack{
            ForEach(0 ..< self.discards.count, id: \.self) { number in
              CardImage(cardID: number)
            }
          }.padding([.leading, .trailing], 20)
        }
        Color.clear
        ZStack {
          ForEach(0 ..< self.hand.count, id: \.self) { number in
            CardImage(cardID: number)

          }
        }
        VStack{
          Color.clear
          HStack {
            Button(action: {
              self.clearTable()
            }) {
              Text("Clear Table")
            }.padding()
            Button(action: {
              self.loadDeck()
            }) {
              Text("Load Deck")
            }.padding()
          }
        }
      }
    }.background(Color.green)
      .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
      .onAppear {
        self.loadDeck()
    }
  }
  
  func clearTable() {
    self.deck.removeAll()
    self.hand.removeAll()
    self.discards.removeAll()
  }
  
  func loadDeck() {
    self.clearTable()
    self.deck.removeAll()
    self.hand.removeAll()
    self.discards.removeAll()
    for index in (0...52) {
      self.deck.append(index)
    }
    for _ in 0...3 {
      self.deck.append(joker)
    }
    //    self.deck = self.deck.shuffled()
    for _ in (0...10) {
      self.hand.append(self.deck.last!)
      self.deck.removeLast()
    }
    self.hand.append(aSpacer)
    for _ in (0...0) {
      self.discards.append(self.deck.last!)
      self.deck.removeLast()
    }
    self.hand.sort()
    print(self.deck)
    print(self.hand)
    print(self.discards)
    //   self.hand = self.hand.shuffled()
    
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
