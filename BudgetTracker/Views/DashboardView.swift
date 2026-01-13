struct DashboardView: View {
    @ObservedObject var viewModel: BudgetViewModel

    var body: some View {
        VStack {
            Text("Balance: \(viewModel.balance)")
            Text("Income: \(viewModel.income)")
            Text("Expenses: \(viewModel.expense)")
        }
    }
}