//
//  Card.swift
//  Threes
//
//  Created by John James Retina on 8/11/17.
//  Copyright © 2017 John James. All rights reserved.
//

import SwiftUI

//let suits = ["Hearts", "Clubs", "Diamonds", "Spades", "Joker"]
//let rankNames = ["Ace","2","3","4","5","6","7","8","9","10","Jack","Queen","King"]
//
//let ranks =   [ 1,2,3,4,5, 6,7,8,9,10, 11,12,13]
let penaltyPoints =  [20,2,3,4,5, 6,7,8,9,10, 10,10,10]
let jokerPoints = 50

//let Joker = 13
//let Spacer = 14
let names =  ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King", "Joker", "Spacer" ]

class  Card1 {
    
    var ID : Int {
        didSet(newValue){
            if newValue < 0 {
                ID = 0
            }
            if newValue > 53 {
                ID = newValue % 53
            }
        }
    }
    
    init(id : Int) {
        ID = id
    }
    
    func isJoker() -> Bool {
        if ID == 52 {
            return true
        }
        return false
    }
    func isSameSuit(card1 : Int, card2 : Int){
        
    }
    
    func suit() -> String {
        return suits[(ID % 53) / 13]
    }
    
    func rank()->Int {
        return (ID % 53) % 13
    }
    
    func description() -> String {
        if isJoker() {
            return ("Joker Points \(points())")
        } else {
            return ("Suit \(suit()) Rank \(names[rank()]) Points \(points()) ")
        }
    }
    
    func points()-> Int {
        if isJoker() {
            return jokerPoints
        }
        return penaltyPoints[rank()]
    }
}



class Card{
    var rank = ranks[0]
    var suit = suits[4]
    var value = penaltyPoints[0]
    var suitRank = 0
    var deck = 0
    var tagID = 1
    var image = UIImage()
    var name = String()
    var animating = false
    
    class func makeCard(tag : Int, rank : Int, suit : Int, deck : Int)-> Card{
        
        let card = Card()
        card.tagID = tag
        card.rank = ranks[rank]
        card.value = penaltyPoints[rank]
        card.image = cardImage(suitName: suits[suit], rank: card.rank)
        card.deck = deck
        if rank == ranks[joker] || rank == ranks[ Spacer] {
            card.suit = suits[4]  // set joker to own suit
        } else {
            card.suit = suits[suit]
        }
      card.suitRank = suits.firstIndex(of: card.suit)!
        return card
    }
    
    class func makeDeck()-> [Card]{
        
        var deck = [Card]()
        var tag = 101
        for deckID in 0...1{
            for suit in 0...3{
                for rank in 0...13{
                    if rank < joker || suit < 2{
                        tag = (deckID + 1) * 1000
                        tag = tag + ((rank + 1) + (suit * 100))
                        let card = makeCard(tag: tag, rank: rank, suit: suit, deck: deckID)
                        card.name = names[rank]
                        deck.append(card)
//                        tag += 1
                    }
                }
            }
        }
        return deck
    }
    
    class func cardValueImage(suitName : String,rank : Int) -> UIImage {
        
        // Used to crop images for the slider
        
        var offset = 0
        let rank = rank - 1
        
        if rank > 4 {
            offset = 1
        }
        if rank > 9 {
            offset = 2
        }
        
        let cgImage = UIImage(named: suitName)?.cgImage
        let originX = CGFloat(204 * (rank % 5)) + 1.0
        let originY = CGFloat(265 * offset) + 13.0
        let cardWidth : CGFloat = 22.0
        let cardHeight : CGFloat = 30.0
        
        if let cropped = cgImage?.cropping(to: CGRect(x: originX, y: originY, width: cardWidth, height: cardHeight)){
            let uiImage  = UIImage(cgImage: cropped)
            return uiImage
        }
        return UIImage()
    }
    
    class func cardImage(suitName : String,rank : Int) -> UIImage {
        
        // Used to crop image from suit sheets
        
        var offset = 0
        let rank = rank - 1
        
        if rank > 4 {
            offset = 1
        }
        if rank > 9 {
            offset = 2
        }
        
        let cgImage = UIImage(named: suitName)?.cgImage
        let x : CGFloat = CGFloat( 204 * (rank % 5))
        let y : CGFloat = CGFloat (265 * offset)
        
        if let cropped = cgImage?.cropping(to: CGRect(x: x - 2 , y: y, width: 180, height: 252 + 2)){
            let uiImage  = UIImage(cgImage: cropped)
            return uiImage
        }
        return UIImage()
    }
    
    class func shuffleDeck(deck : [Card])-> [Card]{
        
        var deck = deck

        for index in 1...100{
            deck.swapAt(index % deck.count, Array<Any>.Index(arc4random_uniform(UInt32( deck.count))))
        }
        return deck
    }

    
    class func sortBySuitRank(cards : [Card]) -> [Card]{
        var hand = cards
        hand = hand.sorted { t1, t2 in
            if t1.suitRank == t2.suitRank {
                return t1.rank < t2.rank
            }
            else {
                return t1.suitRank < t2.suitRank
            }
        }
        return hand
    }
    
    class func allCardsMakeBook(hand : [Card], wild : Int)-> Bool{
        
        if hand.count < 3 {
            return false
        }
        
        var sorted = Card.sortBySuitRank(cards: hand)
        sorted = sorted.filter { $0.name != "Joker" }
        sorted = sorted.filter { $0.rank != wild }
        
        for card in sorted {
            if card.rank != sorted.first?.rank {
                return false
            }
        }
        return true
    }

    class func allCardsMakeRun(hand : [Card], wild : Int)-> Bool{
        
        
        if hand.count < 3 {
            return false
        }
        var sorted = Card.sortBySuitRank(cards: hand)
        sorted = sorted.filter { $0.name != "Joker" }
        sorted = sorted.filter { $0.rank != wild }
        
        let wildCardCount = hand.count - sorted.count

        for x in 0..<sorted.count {
            for y in 0..<sorted.count {
                if x != y {
                if sorted[x].rank == sorted[y].rank{
                    // fail if cards are same rank
                    return false
                }
                    if sorted[x].suit != sorted[y].suit{
                        // fail if cards are different suits
                        return false
                    }
                }
            }
        }

        
        var rangeOfCards =  0
        if sorted.count > 0 {
            rangeOfCards = sorted.last!.rank - sorted.first!.rank
        }
        if rangeOfCards > (sorted.count + wildCardCount) {
            if sorted.first?.rank == 1 {
                let HighAce = 14

                sorted.first?.rank = HighAce
                sorted = Card.sortBySuitRank(cards: sorted)
                rangeOfCards = sorted.last!.rank - sorted.first!.rank
                if rangeOfCards >= (sorted.count + wildCardCount) {
                    sorted.last?.rank = 1
                    return false
                }
                sorted.last?.rank = 1
            } else {
                return false
            }
        }
        return true
    }
    
    class func countPoints(hand : [Card], wild : Int) -> Int{
        
        var total = 0
        
        if (allCardsMakeRun (hand: hand, wild: wild)){
//            print("\n***** Run *****")
//
//            Card.displayCards(hand: hand)

            return total
        }
        if (allCardsMakeBook(hand: hand, wild: wild))  {
//            print("\n***** Book *****")
//
//            Card.displayCards(hand: hand)

            return total
        }
        
//        print("\n***** Points *****")
//
//        Card.displayCards(hand: hand)
        for card in hand {

            
            if card.rank == wild {
                total += penaltyPoints[joker]
            } else {
                total += card.value
            }
        }
        return total
    }

    
    class func displayCards(hand : [Card]){
        for card in hand {
            card.detail()
        }
    }

    func detail() {
        print("\(name) \(suit) Rank \(rank) Tag \(tagID) Points \(value)")
    }
}
