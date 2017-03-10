//
//  Pokemon.swift
//  13-pokedex
//
//  Created by Alex Comunian on 07/03/17.
//  Copyright © 2017 Hackademy. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    // data protection -> Getter
    var nextEvolutionLevel: String{
        if _nextEvolutionLevel == nil{
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionId: String{
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionName: String{
        if _nextEvolutionName == nil{
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String{
        if _nextEvolutionTxt == nil{
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId!)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete){
        // GET Request
        Alamofire.request(_pokemonURL).responseJSON{ (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                if let name = dict["name"] as? String{
                    self._name = name
                }
                
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0{
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    for x in 1..<types.count{
                        if let name = types[x]["name"] {
                            self._type! += "/\(name.capitalized)"
                        }
                    }
                    
                    
                } else{
                    self._type = "NO_TYPE"
                }
                
                if let descriptionArray = dict["descriptions"] as? [Dictionary<String, String>], descriptionArray.count > 0{
                    if let url = descriptionArray[0]["resource_uri"]{
                        let descriptionURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descriptionURL).responseJSON{(response) in
                            if let responseDict = response.result.value as? Dictionary<String, AnyObject>{
                                if let pokeDescription = responseDict["description"] as? String{
                                    self._description = pokeDescription.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                }
                            }
                            completed()
                        }
                    }
                }else{
                    self._description = "No description provided"
                }
                
                if let evoArray = dict["evolutions"] as? [Dictionary<String, AnyObject>], evoArray.count > 0 {
                    if let nextEvo = evoArray[0]["to"] as? String{
                        if nextEvo.range(of: "mega") == nil{
                            self._nextEvolutionName = nextEvo
                            if let uri = evoArray[0]["resource_uri"] as? String{
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                self._nextEvolutionId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                if let lvlExist = evoArray[0]["level"] {
                                    if let lvl = lvlExist as? Int{
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                }else{
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
    
}








