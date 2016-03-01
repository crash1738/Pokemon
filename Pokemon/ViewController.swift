//
//  ViewController.swift
//  Pokemon
//
//  Created by 昆翰 蔡 on 2016/2/29.
//  Copyright © 2016年 昆翰 蔡. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    let screenwidth = UIScreen.mainScreen().bounds.width
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarHidden = true
        
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        initAudio()
        parsePokemonCSV()
    }
    
    func initAudio(){
        
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
        
    }
    
    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows{
                
              let pokemonId = Int(row["id"]!)!
              let name = row["identifier"]!
              let poke = Pokemon(name: name, pokemonId: pokemonId)
                pokemon.append(poke)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath) as? PokemonCell {
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            cell.configureCell(poke)
            return cell
        }else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke: Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]

        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var cell_w: CGFloat!
        var cell_h: CGFloat!
        
        if screenwidth == 320 {
            //兩列：135 三列:85
            cell_w = 85
            cell_h = 85
            //return CGSizeMake(135, 135)
        }else if screenwidth >= 375{
            cell_w = 105
            cell_h = 105
            //return CGSizeMake(105, 105)
        }
        return CGSizeMake(cell_w,cell_h)
        
    }

    @IBAction func musicBtnPressed(sender: UIButton!) {
        
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.setImage(UIImage(named: "mute.png"), forState: .Normal)
        } else {
            musicPlayer.play()
            sender.setImage(UIImage(named: "music.png"), forState: .Normal)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }


    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            view.endEditing(true)
            collectionView.reloadData()
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercaseString
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            collectionView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailVC.pokemon = poke
                }
            }
        }
    }
    
}

