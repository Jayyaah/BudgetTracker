import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: BudgetViewModel
    @State private var isShowingAddTransaction = false

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()

    private func formatted(_ amount: Decimal) -> String {
        currencyFormatter.string(
            from: NSDecimalNumber(decimal: amount)
        ) ?? "0 €"
    }

    var body: some View {
        NavigationStack {
            List {

                // Dashboard section
                Section {
                    VStack(spacing: 16) {

                        VStack(spacing: 12) {
                            Text("balance")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(formatted(viewModel.balance))
                                .font(.largeTitle.bold())
                                .foregroundStyle(viewModel.balance >= 0 ? .green : .red)

                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("incomes")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text(formatted(viewModel.income))
                                        .foregroundStyle(.green)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("expenses")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text(formatted(viewModel.expense))
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                        Button {
                            isShowingAddTransaction = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("add_transaction")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    .padding(.vertical)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // Transactions section
                Section {
                    ForEach(viewModel.transactions) { transaction in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(transaction.description)
                                Text(transaction.type == .income ? "income" : "expense")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(transaction.date, style: .date)
                            }

                            Spacer()

                            Text(formatted(transaction.amount))
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    transaction.type == .income ? .green : .red
                                )
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let transaction = viewModel.transactions[index]
                            viewModel.removeTransaction(id: transaction.id)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle("dashboard.title")
            .sheet(isPresented: $isShowingAddTransaction) {
                AddTransactionView(viewModel: viewModel)
            }
        }
    }
}
