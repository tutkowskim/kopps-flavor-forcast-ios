//
//  FlavorForecast.swift
//  kopps-flavor-forcast-ios
//
//  Created by Mark Tutkowski on 1/2/21.
//

import Foundation

struct Flavor: Codable {
    let flavor: String
    let description: String
    let image: String
}

struct FlavorForecast: Codable {
    let date: String
    let flavors: [Flavor]
}
