//
//  ViewController.swift
//  devslopes-pokedex
//
//  Created by Egorio on 3/8/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var musicPlayer: AVAudioPlayer!
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]() {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

        searchBar.delegate = self
        searchBar.returnKeyType = .Done

        parsePokemonCSV()
        initAudio()

        filteredPokemons = pokemons
    }

    /*
     * Init background audio to be able switch it on of off
     */
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!

        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

    /*
     * Parse local CSV file with pokemons list
     */
    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!

        do {
            let csv = try CSV(contentsOfURL: path)

            for row in csv.rows {
                let pokemon = Pokemon(pokedexId: Int(row["id"]!)!, name: row["identifier"]!)

                pokemons.append(pokemon)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPokemons.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath) as? PokemonCell
            ?? PokemonCell()

        let pokemon = filteredPokemons[indexPath.row]

        cell.configure(pokemon)

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowPokemonDetails", sender: filteredPokemons[indexPath.row])
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = (collectionView.bounds.width - 2 * 10) / 3
        return CGSize(width: size, height: size)
    }

    /*
     * Hide keyboard by clicking "Done" on keyboard
     */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }

    /*
     * Filter pokemons by changing search string
     */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredPokemons = pokemons
            view.endEditing(true)
        } else {
            filteredPokemons = pokemons.filter({ $0.name.rangeOfString(searchText.lowercaseString) != nil })
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPokemonDetails",
            let controller = segue.destinationViewController as? DetailViewController,
            let pokemon = sender as? Pokemon {

                controller.pokemon = pokemon
        }
    }

    /*
     * Enable or disable background music
     */
    @IBAction func musicToggle(sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 1
        }
        else {
            musicPlayer.play()
            sender.alpha = 0.2
        }
    }
}
