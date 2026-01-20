import SwiftUI

struct AddTransactionView: View {
    @ObservedObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var descriptionText: String = ""
    @State private var amountText: String = ""
    @State private var isIncome: Bool = true
    @State private var date: Date = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                // Card summary (type + amount)
                VStack(spacing: 12) {
                    Picker("Type", selection: $isIncome) {
                        Text("Income").tag(true)
                        Text("Expense").tag(false)
                    }
                    .pickerStyle(.segmented)

                    TextField("Amount", text: $amountText)
                        .keyboardType(.decimalPad)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(isIncome ? .green : .red)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                // Details
                Form {
                    Section("Details") {
                        HStack{
                            Image(systemName: "calendar.badge.clock")
                            DatePicker("", selection: $date, displayedComponents: [.date])
                        }
                        
                        TextField("Description", text: $descriptionText)
                    }
                }
                .scrollDisabled(true)

                Spacer()
            }
            .navigationTitle("New Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        guard !descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        return Decimal(string: amountText.replacingOccurrences(of: ",", with: ".")) != nil
    }

    private func save() {
        guard let amount = Decimal(string: amountText.replacingOccurrences(of: ",", with: ".")) else {
            return
        }

        viewModel.addTransaction(
            description: descriptionText,
            amount: amount,
            date: Date(),
            type: isIncome ? .income : .expense
        )

        dismiss()
    }
}
