//
//  DetailViewController.swift
//  devslopes-pokedex
//
//  Created by Egorio on 3/8/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!

    @IBOutlet weak var evolutionLabel: UILabel!
    @IBOutlet weak var currentEvolutionImage: UIImageView!
    @IBOutlet weak var nextEvolutionImage: UIImageView!

    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(pokemon.name)

        nameLabel.text = pokemon.name
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")

        cleanPokemonDetails()

        // Download Pokemon main details and description
        pokemon.downloadPokemonDetails { _ in
            self.pokemon.downloadPokemonDescription({ _ in
                self.fillPokemonDetails()
            })
        }
    }

    /*
     * Clean previous pokemon details
     */
    func cleanPokemonDetails() {
        typeLabel.text = ""
        defenseLabel.text = ""
        heightLabel.text = ""
        weightLabel.text = ""
        pokedexLabel.text = ""
        attackLabel.text = ""
        descriptionLabel.text = ""
        evolutionLabel.text = ""

        currentEvolutionImage.hidden = true
        nextEvolutionImage.hidden = true
    }

    /*
     * Fill UI with pokemon details
     */
    func fillPokemonDetails() {
        typeLabel.text = pokemon.type
        defenseLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        pokedexLabel.text = String(pokemon.pokedexId)
        attackLabel.text = pokemon.attack
        descriptionLabel.text = pokemon.description

        currentEvolutionImage.image = UIImage(named: "\(pokemon.pokedexId)")
        currentEvolutionImage.hidden = false

        if pokemon.nextEvolutionId == "" {
            evolutionLabel.text = "No evalutions"
            nextEvolutionImage.hidden = true
        }
        else {
            evolutionLabel.text = "Next evalution: \(pokemon.nextEvolutionText)"
            // evolutionLabel.text += pokemon.nextEvolutionText == "" ? "" : "LVL \(pokemon.nextEvolutionText)"
            nextEvolutionImage.image = UIImage(named: "\(pokemon.nextEvolutionId)")
            nextEvolutionImage.hidden = false
        }
    }

    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
