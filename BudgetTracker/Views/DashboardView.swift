import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: BudgetViewModel

    var body: some View {
        VStack {
            Text("Balance: \(viewModel.balance)")
            Text("Income: \(viewModel.income)")
            Text("Expenses: \(viewModel.expense)")

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
                        Text("\(transaction.amount)")
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
