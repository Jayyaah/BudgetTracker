import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: BudgetViewModel
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()
    private var formattedIncome: String {
        currencyFormatter.string(
            from: NSDecimalNumber(decimal: viewModel.income)
        ) ?? "0 €"
    }
    private var formattedExpense: String {
        currencyFormatter.string(
            from: NSDecimalNumber(decimal: viewModel.expense)
        ) ?? "0 €"
    }
    private var formattedBalance: String {
        currencyFormatter.string(
            from: NSDecimalNumber(decimal: viewModel.balance)
        ) ?? "0 €"
    }
    private func formattedAmount(_ amount: Decimal) -> String {
        currencyFormatter.string(
            from: NSDecimalNumber(decimal: amount)
        ) ?? "0 €"
    }

    var body: some View {
        VStack {
            Text("Balance: \(formattedBalance)")
            Text("Income: \(formattedIncome)")
            Text("Expenses: \(formattedExpense)")

            Button("Add test income") {
                viewModel.addTransaction(
                    description: "Test Income",
                    amount: 1000.0,
                    date: Date(),
                    type: .income
                )
            }
            Button("Add test expense") {
                viewModel.addTransaction(
                    description: "Test Income",
                    amount: 500.0,
                    date: Date(),
                    type: .expense
                )
            }
            List {
                ForEach(viewModel.transactions) { transaction in
                    HStack {
                        Text(transaction.description)
                        Spacer()
                        Text(formattedAmount(transaction.amount))
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let transaction = viewModel.transactions[index]
                        viewModel.removeTransaction(id: transaction.id)
                    }
                }
            }
        }
    }
}
