//
//  Pokemon.swift
//  devslopes-pokedex
//
//  Created by Egorio on 3/8/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {

    // Hide pokemon original attributes from public access
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: Int!
    private var _defense: Int!
    private var _nextEvolutionId: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionLevel: Int!

    // Additional attributes... they could be in ApiClient class, but for stady I left them here
    private let _baseUrl = "https://pokeapi.co/"
    private var _pokemonUrl: String!
    private var _descriptionUrl: String?
    private var _evalutionUrl: String?

    var name: String {
        return _name == nil ? "" : _name
    }

    var pokedexId: String {
        return _pokedexId == nil ? "" : String(_pokedexId)
    }

    var description: String {
        return _description == nil ? "" : _description
    }

    var type: String {
        return _type == nil ? "" : _type
    }

    var height: String {
        return _height == nil ? "" : _height
    }

    var weight: String {
        return _weight == nil ? "" : _weight
    }

    var attack: String {
        return _attack == nil ? "" : String(_attack)
    }

    var defense: String {
        return _defense == nil ? "" : String(_defense)
    }

    var nextEvolutionId: String {
        return _nextEvolutionId == nil ? "" : _nextEvolutionId
    }

    var nextEvolutionText: String {
        return _nextEvolutionText == nil ? "" : _nextEvolutionText
    }

    var nextEvolutionLevel: String {
        return _nextEvolutionLevel == nil ? "" : String(_nextEvolutionLevel)
    }

    /*
     * Initializer pokemon with main attributes
     */
    init(pokedexId: Int, name: String) {
        _pokedexId = pokedexId
        _name = name
        _pokemonUrl = "\(_baseUrl)api/v1/pokemon/\(_pokedexId)"
    }

    /*
     * Download main pokemon data such as weight, height, defense, attack, type (except description)
     */
    func downloadPokemonDetails(completed: (error: String?) -> ()) {
        Alamofire.request(.GET, NSURL(string: _pokemonUrl)!).responseJSON { response in
            guard let pokemon = response.result.value as? [String: AnyObject] else {
                return completed(error: "Oops! Something is going wrong with getting Pokemon data.")
            }

            self._weight = pokemon["weight"] as? String ?? ""
            self._height = pokemon["height"] as? String ?? ""
            self._defense = pokemon["defense"] as? Int ?? nil
            self._attack = pokemon["attack"] as? Int ?? nil

            self._type = ""
            if let types = pokemon["types"] as? [[String: String]] where types.count > 0 {
                var names = [String]()
                for type in types {
                    if let name = type["name"] {
                        names.append(name)
                    }
                }

                self._type = names.joinWithSeparator(" \\ ")
            }

            self._descriptionUrl = ""
            if let descriptions = pokemon["descriptions"] as? [[String: String]] where descriptions.count > 0 {
                self._descriptionUrl = descriptions[0]["resource_uri"] ?? nil
            }

            if let evolutions = pokemon["evolutions"] as? [[String: AnyObject]] where evolutions.count > 0 {
                if let to = evolutions[0]["to"] as? String where to.rangeOfString("mega") == nil {
                    if let url = evolutions[0]["resource_uri"] {
                        self._nextEvolutionText = to
                        self._nextEvolutionLevel = evolutions[0]["level"] as? Int ?? nil
                        self._nextEvolutionId = url
                            .stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                            .stringByReplacingOccurrencesOfString("/", withString: "")
                    }
                }
            }

            completed(error: nil)
        }
    }

    /*
     * Download main pokemon description
     */
    func downloadPokemonDescription(completed: (error: String?) -> ()) {
        guard let url = _descriptionUrl else {
            // Think as we don't have Pokemon description :)
            return completed(error: nil)
        }

        Alamofire.request(.GET, NSURL(string: "\(_baseUrl)\(url)")!).responseJSON { response in
            guard let descriptions = response.result.value as? [String: AnyObject] else {
                return completed(error: "Oops! Something is going wrong with getting Pokemon data.")
            }

            self._description = descriptions["description"] as? String ?? ""

            completed(error: nil)
        }
    }
}