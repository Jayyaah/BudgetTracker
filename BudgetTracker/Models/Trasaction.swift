//
//  Trasaction.swift
//  BudgetTracker
//
//  Created by Valentine on 07/01/2026.
//
// Struc Transaction qui est un objet qui représente une transaction

import Foundation

struct Transaction: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var description: String
    var amount: Decimal
    var date: Date
    var category: String?
    var categoryType: String?

    init(id: UUID = UUID(), description: String, amount: Decimal, date: Date = Date(), category:String? = nil, categoryType: String? = nil) {
        self.id = id
        self.description = description
        self.amount = amount
        self.date = date
        self.category = category
        self.categoryType = categoryType
    }
}
