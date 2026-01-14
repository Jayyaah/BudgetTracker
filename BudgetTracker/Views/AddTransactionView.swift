import SwiftUI

struct AddTransactionView: View {
    @ObservedObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var descriptionText: String = ""
    @State private var amountText: String = ""
    @State private var isIncome: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Details")) {
                    TextField("Description", text: $descriptionText)
                    TextField("Amount", text: $amountText)
                        .keyboardType(.decimalPad)
                    Picker("Type", selection: $isIncome) {
                        Text("Income").tag(true)
                        Text("Expense").tag(false)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        guard !descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        return Decimal(string: amountText.replacingOccurrences(of: ",", with: ".")) != nil
    }

    private func save() {
        guard let amount = Decimal(string: amountText.replacingOccurrences(of: ",", with: ".")) else { return }

        viewModel.addTransaction(
            description: descriptionText,
            amount: amount,
            date: Date(),
            type: isIncome ? .income : .expense
        )

        dismiss()
    }
}
