//
//  ModelCell.swift
//  Test_WB_Travel
//
//  Created by Bandit on 04.08.2023.
//

import Foundation

struct ModelCell: Codable, Identifiable, Hashable {
    
    var id: UUID
    var imageTravel: String
    var departureCity: String
    var arrivalCity: String
    var modeOfTravel: String
    var departureDate: String
    var returnDate: String
    var price : String
    var addToFavorites: Bool
    var available: Bool
    
}
