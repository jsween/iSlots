//
//  InfoView.swift
//  iSlots
//
//  Created by Jonathan Sweeney on 11/27/20.
//

import SwiftUI

struct InfoView: View {
    // MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section(header: Text("About the application")) {
                    FormRowView(firstItem: "Application", secondItem: "iSlots")
                    FormRowView(firstItem: "Platforms", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Jonathan Sweeney")
                    FormRowView(firstItem: "Designer", secondItem: "Jonathan Sweeney")
                    FormRowView(firstItem: "Music", secondItem: "Dan Lebowitz")
                    FormRowView(firstItem: "Website", secondItem: "jsween.com")
                    FormRowView(firstItem: "Copyright", secondItem: "© 2020 All rights reserved")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                }
            }//: FORM
            .font(.system(.body, design: .rounded))
        }//: VSTK
        .padding(.top, 40)
        .overlay(
            Button(action: {
                audioPlayer?.stop()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }
            .padding(.top, 30)
            .padding(.trailing, 20)
            .accentColor(Color.secondary)
            , alignment: .topTrailing
        )
        .onAppear(perform: {
            playSound(sound: "background-music")
        })
        .onDisappear(perform: {
            audioPlayer?.stop()
        })
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    var body: some View {
        HStack {
            Text(firstItem).foregroundColor(.gray)
            Spacer()
            Text(secondItem)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
