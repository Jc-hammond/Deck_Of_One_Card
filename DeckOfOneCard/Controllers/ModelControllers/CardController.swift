//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Connor Hammond on 5/4/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

class CardController {
    
    //MARK: - String Constants
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck")
    static let newCardPathComponent = "/new/draw"
    
    static func fetchCard(completion: @escaping (Result <Card, CardError>) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let newCardURL = baseURL.appendingPathComponent(newCardPathComponent)
        print(newCardURL)
        // 2 - Contact server
        URLSession.shared.dataTask(with: newCardURL) { data, _, error in
            // 3 - Handle errors from the server
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            // 4 - Check for json data
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let topLevel = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLevel.cards.first else {return completion(.failure(.noData))}
                return completion(.success(card))
            } catch {
                print(error)
                completion(.failure(.thrownError(error)))
            }
            // 5 - Decode json into a Card
            do {
                let card = try JSONDecoder().decode(Card.self, from: data)
                completion(.success(card))
            } catch {
                print(error)
                completion(.failure(.thrownError(error)))
            }
        }.resume()
        
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void) {
           
        guard let url = card.image else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            completion(.success(image))
            
        }.resume()
  
        }
    
    
    } //End of class
