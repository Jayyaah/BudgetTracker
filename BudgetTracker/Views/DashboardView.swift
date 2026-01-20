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
    
    private let dateFormatter: DateFormatter = {
        let dateFromat = DateFormatter()
        dateFromat.calendar = Calendar(identifier: .gregorian)
        dateFromat.locale = Locale(identifier: "fr_FR")
        dateFromat.dateFormat = "dd/MM/yyyy"
        return dateFromat
    }()

    var body: some View {
        NavigationStack {
            List {

                // Dashboard section
                Section {
                    VStack(spacing: 16) {

                        VStack(spacing: 8) {
                            Text("balance")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(formatted(viewModel.balance))
                                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                                .monospacedDigit()
                                .foregroundStyle(viewModel.balance >= 0 ? .green : .red)

                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("incomes")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text(formatted(viewModel.income))
                                        .font(.callout.weight(.semibold))
                                        .foregroundStyle(.green)
                                        .monospacedDigit()
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("expenses")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text(formatted(viewModel.expense))
                                        .font(.callout.weight(.semibold))
                                        .foregroundStyle(.red)
                                        .monospacedDigit()
                                }
                            }
                        }
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.vertical)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // Transactions section
                Section {
                    ForEach(viewModel.transactions) { transaction in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(transaction.type == .income ? Color.green : Color.red)
                                .frame(width: 6, height: 6)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(transaction.description)
                                    .font(.body)

                                Text(dateFormatter.string(from: transaction.date))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(formatted(transaction.amount))
                                .font(.body.weight(.semibold))
                                .monospacedDigit()
                                .foregroundStyle(transaction.type == .income ? .green : .red)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let transaction = viewModel.transactions[index]
                            viewModel.removeTransaction(id: transaction.id)
                        }
                    }
                } header: {
                    Text("transactions")
                        .textCase(nil)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle("dashboard.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel(Text("add_transaction"))
                }
            }
            .sheet(isPresented: $isShowingAddTransaction) {
                AddTransactionView(viewModel: viewModel)
            }
        }
    }
}

