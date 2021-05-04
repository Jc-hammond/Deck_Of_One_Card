//
//  Card.swift
//  DeckOfOneCard
//
//  Created by Connor Hammond on 5/4/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import Foundation

struct Card: Decodable {
    
    let value: String
    let suit: String
    let image: URL?
    
}//End of struct

struct TopLevelObject: Decodable {
    
    let cards: [Card]
    
}
