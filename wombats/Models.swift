//
//  Models.swift
//  wombats
//
//  Created by Samuel Shiffman on 7/24/16.
//  Copyright © 2016 Sam Shiffman. All rights reserved.
//

import Foundation


struct Frame {
    let map: Map
}

struct Map {
    let rows: [Row]
}

struct Row {
    let spaces: [Space]
}

struct Space {
    enum Kind {
        case player(Player)
        case open(Open)
        case block(Block)
        case food(Food)
        case ai(AI)
    }

    let kind: Kind

//    let uuid: Int?

    struct Player {
        let energy: Int
    }
    
    struct Open: Displayable {
        let display: String
    }
    
    struct Block: Displayable {
        let display: String
    }
    
    struct Food {
        
    }
    
    struct AI {
        let uuid: Int
    }
}


protocol Displayable {
    var display: String { get }
}

protocol HasEnergy {
    var energy: Int { get }
}

protocol HasTransparancy {
    var transparancy: Bool { get }
}



extension Row: JSONDecodable {
    static func decodeJSON(json: AnyObject) throws -> Row {
        let arrayOfSpaces = json as! NSArray
        var spaces = [Space]()
        for space in arrayOfSpaces {
            let sp = try! Space.decodeJSON(json: space)
            spaces.append(sp)
        }

        return Row(spaces: spaces)
    }
}

extension Map: JSONDecodable {
    static func decodeJSON(json: AnyObject) throws -> Map {
        let arrayOfRows = json as! NSArray
        let rows = try! arrayOfRows.map(Row.decodeJSON)
        return Map(rows: rows)
    }
}


extension Frame: JSONDecodable {
    static func decodeJSON(json: AnyObject) throws -> Frame {
        let json = JSON(dict: json as! NSDictionary)
        let maps = try json.requiredArray(key: "map")
        let map = try! Map.decodeJSON(json: maps as AnyObject)
        return Frame(map: map)
    }
}


extension Space: JSONDecodable {
    static func decodeJSON(json: AnyObject) throws -> Space {
        let json = JSON(dict: json as! NSDictionary)
        let type = try json.requiredString(key: "type")
        
        switch type {
        case "player":
            return Space(kind: Space.Kind.player(try! Player.decodeJSON(json: json.dict)))
        case "food":
            return Space(kind: Space.Kind.food(try! Food.decodeJSON(json: json.dict)))
        case "open":
            return Space(kind: .open(try! Open.decodeJSON(json: json.dict)))
        case "ai":
            return Space(kind: .ai(try! AI.decodeJSON(json: json.dict)))
        case "block":
            return Space(kind: .block(try! Block.decodeJSON(json: json.dict)))
        default:
            fatalError("Unhandled type")
        }
    }
}

extension Space.Player: JSONDecodable {
    static func decodeJSON(json: AnyObject) throws -> Space.Player {
        let json = JSON(dict: json as! NSDictionary)
        let energy = try! json.requiredInt(key: "energy")
        return Space.Player(energy: energy)
    }
}

extension Space.Food: JSONDecodable {
    static func decodeJSON(json: AnyObject) throws -> Space.Food {
//        let json = JSON(dict: json as! NSDictionary)
        return Space.Food()
    }
}

extension Space.Open: JSONDecodable {
    static func decodeJSON(json: AnyObject) throws -> Space.Open {
        let json = JSON(dict: json as! NSDictionary)
        let display = try! json.requiredString(key: "display")
        return Space.Open(display: display)
    }
}

extension Space.AI: JSONDecodable {
    static func decodeJSON(json: AnyObject) throws -> Space.AI {
        let json = JSON(dict: json as! NSDictionary)
        let uuid = try! json.requiredInt(key: "uuid")
        return Space.AI(uuid: uuid)
    }
}

extension Space.Block: JSONDecodable {
    static func decodeJSON(json: AnyObject) throws -> Space.Block {
        let json = JSON(dict: json as! NSDictionary)
        let display = try! json.requiredString(key: "display")
        return Space.Block(display: display)
    }
}


// open block AI



































