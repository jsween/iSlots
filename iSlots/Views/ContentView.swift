//
//  ContentView.swift
//  iSlots
//
//  Created by Jonathan Sweeney on 11/27/20.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - PROPERTIES
    
    let symbols = [Symbols.bell.rawValue, Symbols.cherry.rawValue, Symbols.coin.rawValue, Symbols.grape.rawValue, Symbols.seven.rawValue, Symbols.strawberry.rawValue]
    
    @State private var highScore: Int = 0
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels: Array = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    @State private var bet10: Bool = true
    @State private var bet20: Bool = false
    
    // MARK: - FUNCTIONS
    
    // SPIN REELS
    func spinReels() {
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
    }
    // CHECK THE WINNING
    func checkWinning() {
        if reels[0] == reels[1] && reels[0] == reels[2] {
            // PLAYER WINS
            coins += betAmount * 20
            // NEW HIGH SCORE
            if coins > highScore {
                highScore = coins
            }
        } else {
            // PLAYER LOSES
            coins -= betAmount
        }
    }
    // GAME OVER
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            // MARK: - BKGRND
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom).ignoresSafeArea(edges: .all)
            // MARK: - INTERFACE
            VStack(alignment: .center, spacing: 5) {
                // MARK: - HEADER
                LogoView()
                    .padding(.vertical, 5)
                Spacer()
                // MARK: - SCORE
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }//: HSTK
                    .modifier(ScoreContainerModifier())
                    Spacer()
                    HStack {
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }//: HSTK
                    .modifier(ScoreContainerModifier())
                }//: HSTK
                // MARK: - SLOT MACHINE
                VStack(alignment: .center, spacing: 0) {
                    // MARK: - REEL 1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    HStack(alignment: .center, spacing: 5) {
                        // MARK: - REEL 2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                        Spacer()
                        // MARK: - REEL 3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    }//: HSTK
                    .frame(maxWidth: 500)
                    // MARK: - SPIN BUTTON
                    Button(action: {
                        self.spinReels()
                        self.checkWinning()
                    }) {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    
                }//: SLOT MACHINE
                .layoutPriority(2)
                // MARK: - FOOTER
                
                Spacer()
                
                HStack {
                    // MARK: - BET 20
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            self.betAmount = 20
                            self.bet20 = true
                            self.bet10 = false
                        }) {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(bet20 ? Color("ColorYellow") : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(bet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    // MARK: - BET 10
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(bet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            self.betAmount = 10
                            self.bet10 = true
                            self.bet20 = false
                        }) {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(bet10 ? Color("ColorYellow") : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                    }
                }
            }//: VSTK
            // MARK: - BUTTONS
            .overlay(
                // RESET
                Button(action: {
                    print("Reset Game")
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                // INFO
                Button(action: {
                    self.showingInfoView = true
                }) {
                    Image(systemName: "info.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
        }//: ZSTK
        .sheet(isPresented: $showingInfoView, content: {
            InfoView()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12 Pro")
    }
}
