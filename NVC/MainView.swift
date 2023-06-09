//
//  MainView.swift
//  NVC
//
//  Created by Jesse Shepard & ChatGPT on 6/5/23.
//

import SwiftUI

struct MainView: View {
    @State private var isAboutViewPresented: Bool = false
    @State private var isApiKeyViewPresented: Bool = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            RephraseView().environmentObject(appState)
                .navigationBarTitle(appState.isRespondMode ? "Respond to their words" : "Rephrase my own words",
                                    displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        self.isAboutViewPresented = true
                    }, label: {
                        Text("About")
                            .foregroundColor(.white)
                    })
                )
                .sheet(isPresented: $isAboutViewPresented) {
                    AboutView()
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.white)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
