//
//  PokemonCell.swift
//  devslopes-pokedex
//
//  Created by Egorio on 3/8/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var pokemon: Pokemon!
    
    func configure(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        label.text = pokemon.name.capitalizedString
        thumb.image = UIImage(named: "\(pokemon.pokedexId)")
    }
    
}
