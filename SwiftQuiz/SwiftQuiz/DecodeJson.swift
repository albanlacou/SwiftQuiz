//
//  DecodeJson.swift
//  SwiftQuiz
//
//  Created by Alban on 07/04/2022.
//

import Foundation


struct infoAPI : Decodable {
    let coord : [String : Int]
    let weather : [weather]
    let base : String
    let main : [String: Double]
    let visibility : Int
    let wind : [String : Double]
    let clouds : [String : Int]
    let dt : Int
    let sys : [sys]
    let timezone : Int
}

struct weather : Decodable {
    let id : Int
    let main : String
    let description : String
    let icon : String
}

struct sys : Decodable{
    let type : Int
    let id : Int
    let country : String
    let sunrise : Int
    let sunset : Int
}
