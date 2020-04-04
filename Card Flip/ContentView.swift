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
let backOfCard = 14
let joker = 13
let Spacer = 15

struct ContentView: View {
  @State var card = 45.0
  @State var flipAngle = Double.pi / 1.0
  @State var rotateAngle = 0.0
  @State var deck = [Int]()
  @State var discards = [Int]()
  @State var hand = [Int]()
  
  var body: some View {
    GeometryReader { geometry in
      //    Text("Hello")
      VStack {
        HStack{
          ZStack {
            ForEach(0 ..< self.deck.count, id: \.self) { number in
              Image(uiImage:  cardImage(cardNumber: self.deck[number]))
                .resizable()
                .frame(width: geometry.size.width / 3, height: (geometry.size.width / 3) * 254 / 180)
                .scaledToFit()
                .offset(x: CGFloat(number * 2), y: CGFloat(number * -3))
            }
          }.padding(.trailing, 50)
          ZStack{
            ForEach(0 ..< self.discards.count, id: \.self) { number in
              Image(uiImage:  cardImage(cardNumber: self.discards[number]))
                .resizable()
                .frame(width: geometry.size.width / 3, height: (geometry.size.width / 3) * 254 / 180)
                .scaledToFit()
                .offset(x: CGFloat(number * 2), y: CGFloat(number * -3))
            }
          }
        }.padding(.leading, 50)
        ZStack {
          ForEach(0 ..< self.hand.count, id: \.self) { number in
            Image(uiImage:  cardImage(cardNumber: self.hand[number]))
              .resizable()
              .frame(width: geometry.size.width / 3, height: (geometry.size.width / 3) * 254 / 180)              .scaledToFit()
              .offset(x: CGFloat(number - self.hand.count / 3) * 20.0, y: CGFloat(number) * 2.0)
            
          }
        }
      }


    }.background(Color.green)
      .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
      .onAppear {
        self.loadDeck()
    }
  }
  
  
  func loadDeck() {
    for index in (0...53) {
      self.deck.append(index)
    }
    self.deck = self.deck.shuffled()
    for _ in (0...7) {
      self.hand.append(self.deck.last!)
      self.deck.removeLast()
    }
    for index in (0...1) {
      self.discards.append(index)
    }
    self.discards.append(self.deck.last!)
    self.deck.removeLast()
//    self.deck.remove(at: self.deck.count)
    self.hand = self.hand.shuffled()
    self.hand.append(backOfCard)
    self.hand.append(joker)
  }
}

func cardImage(cardNumber : Int) -> UIImage {
  
  // Used to crop image from suit sheets
  
  let card = getCard(cardNumber: cardNumber)
  var offset = 0
  var rank = card.rank - 1
  let suit = card.suit
  
  if rank > 4 {
    offset = 1
  }
  if rank > 9 {
    offset = 2
  }
  
  if cardNumber == backOfCard  || cardNumber == Spacer {
    offset = 2
    rank = 4
  }
  if cardNumber == joker {
    offset = 2
    rank = 3
  }
  
  let cgImage = UIImage(named: suit)?.cgImage
  let x : CGFloat = CGFloat( 204 * (rank % 5))
  let y : CGFloat = CGFloat (265 * offset)
  
  if let cropped = cgImage?.cropping(to: CGRect(x: x - 2 , y: y, width: 180, height: 252 + 2)){
    let uiImage  = UIImage(cgImage: cropped)
    return uiImage
  }
  return UIImage()
}

func getCard(cardNumber : Int) -> (suit : String , rank : Int){
  let suit = suits[ (cardNumber / 13) % 4]
  let rank = ranks[ cardNumber % 13]
  return ( suit, rank)
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
