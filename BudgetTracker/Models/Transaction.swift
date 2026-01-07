//
//  Trasaction.swift
//  BudgetTracker
//
//  Created by Valentine on 07/01/2026.
//
// Struc Transaction qui est un objet qui représente une transaction

import Foundation

    struct Transaction: Identifiable, Codable, Hashable {
        
        enum TransactionType: String, Codable, Hashable {
            case income
            case expense
        }

        let id: UUID
        let description: String
        let amount: Decimal
        let date: Date
        let type: TransactionType

    }
