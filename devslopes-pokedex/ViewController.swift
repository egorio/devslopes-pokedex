//
//  ViewController.swift
//  devslopes-pokedex
//
//  Created by Egorio on 3/8/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

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
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = (collectionView.bounds.width - 2 * 10) / 3
        return CGSize(width: size, height: size)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredPokemons = pokemons
            view.endEditing(true)
        } else {
            filteredPokemons = pokemons.filter({ $0.name.rangeOfString(searchText.lowercaseString) != nil })
        }
    }

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
