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
                    amount: 1000.0,
                    date: Date(),
                    type: .expense
                )
            }
        }
    }
}