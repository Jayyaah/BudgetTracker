//
//  ContentView.swift
//  BudgetTracker
//
//  Created by Valentine on 07/01/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = BudgetViewModel()

    var body: some View {
        VStack {
            DashboardView(viewModel: viewModel)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
