//
//  PokemonCell.swift
//  Pokemon
//
//  Created by 昆翰 蔡 on 2016/2/29.
//  Copyright © 2016年 昆翰 蔡. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokemonId)")
        
    }
    
}
