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
    
    @State private var isShowingAddTransaction = false


    var body: some View {
        
        VStack {
            Text("Balance: \(formattedBalance)")
            Text("Income: \(formattedIncome)")
            Text("Expenses: \(formattedExpense)")

            Button("Add Transaction") {
                isShowingAddTransaction = true
            }
            .sheet(isPresented: $isShowingAddTransaction) {
                AddTransactionView(viewModel: viewModel)
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
