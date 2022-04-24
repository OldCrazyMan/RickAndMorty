//
//  Character.swift
//  RickAndMorty
//
//  Created by Тимур Ахметов on 24.04.2022.
//

import Foundation

// MARK: - Character
struct Character: Codable {
    let info: Info
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let location: Location
    let image: String
    let episode: [String]?
}

// MARK: - Location
struct Location: Codable {
    let name: String
}

// MARK: - Info
struct Info: Codable {
    let count: Int
    let next: String
}
