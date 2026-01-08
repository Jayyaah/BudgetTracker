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
    }

    func removeTransaction(id: UUID) {
        transactions.removeAll { $0.id == id }
    }

    func calculateExpenses() -> Decimal {
        transactions
            .filter { $0.type == .expense }
            .reduce(Decimal.zero) { $0 + $1.amount }
    }

    func calculateIncome() -> Decimal {
        transactions
            .filter { $0.type == .income }
            .reduce(Decimal.zero) { $0 + $1.amount }
    }

    func calculateBalance() -> Decimal {
        calculateIncome() - calculateExpenses()
    }
}
