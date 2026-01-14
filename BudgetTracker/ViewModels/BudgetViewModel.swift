//
//  BudgetViewModel.swift
//  BudgetTracker
//
//  Created by Valentine on 07/01/2026.
//

import Foundation
import Combine

final class BudgetViewModel: ObservableObject {

    @Published private(set) var transactions: [Transaction] = []
    private let transactionsKey = "transactions"

    init() {
            loadTransactions()
    }
    
    func addTransaction(
        description: String,
        amount: Decimal,
        date: Date,
        type: Transaction.TransactionType
    ) {
        let transaction = Transaction(
            id: UUID(),
            description: description,
            amount: amount,
            date: date,
            type: type
        )

        transactions.append(transaction)
        saveTransactions()
    }

    func removeTransaction(id: UUID) {
        transactions.removeAll { $0.id == id }
        saveTransactions()
    }
    
    private func saveTransactions() {
            do {
                let data = try JSONEncoder().encode(transactions)
                UserDefaults.standard.set(data, forKey: transactionsKey)
            } catch {
                print("Failed to save transactions:", error)
            }
    }
    
    private func loadTransactions() {
            guard let data = UserDefaults.standard.data(forKey: transactionsKey) else {
                return
            }

            do {
                transactions = try JSONDecoder().decode([Transaction].self, from: data)
            } catch {
                print("Failed to load transactions:", error)
            }
    }

    var expense: Decimal {
        transactions
            .filter { $0.type == .expense }
            .reduce(Decimal.zero) { $0 + $1.amount }
    }

    var income: Decimal {
        transactions
            .filter { $0.type == .income }
            .reduce(Decimal.zero) { $0 + $1.amount }
    }

    var balance: Decimal {
        income - expense
    }
}
