//
//  RestaurantDetail.swift
//  Final
//
//  Created by PJ Shalhoub on 11/22/17.
//  Copyright © 2017 PJ Shalhoub. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

class SportsDetail: Codable {
    var stadiumName: String
    var teamName: String
    var stadiumInfo: String
    var stars: Int
    var placeDocumentID: String
    
    init(stadiumName: String, teamName: String, stadiumInfo: String, stars: Int, placeDocumentID: String) {
        self.stadiumName = stadiumInfo
        self.teamName = teamName
        self.stadiumInfo = stadiumInfo
        self.stars = stars
        self.placeDocumentID = placeDocumentID
    }
    

}
