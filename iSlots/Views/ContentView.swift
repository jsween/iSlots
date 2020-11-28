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
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels: Array = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    @State private var bet10: Bool = true
    @State private var bet20: Bool = false
    @State private var showingModal: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModal: Bool = false
    
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
            coins += assignWinnings()
            // NEW HIGH SCORE
            if coins > highScore {
                highScore = coins
                UserDefaults.standard.set(highScore, forKey: "HighScore")
            }
        } else {
            // PLAYER LOSES
            coins -= betAmount
        }
    }
    // ASSIGN WINNINGS
    func assignWinnings() -> Int {
        switch symbols[reels[0]] {
        case Symbols.cherry.rawValue:
            return betAmount * 50
        case Symbols.seven.rawValue:
            return betAmount * 40
        case Symbols.coin.rawValue:
            return betAmount * 30
        default:
            return betAmount * 20
        }
    }
    // GAME OVER
    func gameOver() {
        if coins <= 0 {
            // SHOW MODAL
            showingModal = true
        }
    }
    // RESET
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        bet10 = true
        bet20 = false
    }
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            // MARK: - BACKGROUND
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom).ignoresSafeArea(edges: .all)
            // MARK: - INTERFACE
            VStack(alignment: .center, spacing: 5) {
                // MARK: - HEADER5
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
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear(perform: {
                                self.animatingSymbol.toggle()
                            })
                    }
                    HStack(alignment: .center, spacing: 5) {
                        // MARK: - REEL 2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)))
                                .animation(.easeOut)
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        }
                        Spacer()
                        // MARK: - REEL 3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 1.0...1.2)))
                                .animation(.easeOut)
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        }
                    }//: HSTK
                    .frame(maxWidth: 500)
                    // MARK: - SPIN BUTTON
                    Button(action: {
                        withAnimation {
                            self.animatingSymbol = false
                        }
                        self.spinReels()
                        withAnimation {
                            self.animatingSymbol = true
                        }
                        self.checkWinning()
                        self.gameOver()
                    }) {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                            .padding(.vertical, 5)
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
                            .offset(x: bet20 ? 0 : 20)
                            .opacity(bet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }
                    Spacer()
                    
                    // MARK: - BET 10
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(bet10 ? 1 : 0)
                            .offset(x: bet10 ? 0 : -20)
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
                    self.resetGame()
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
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            
            // MARK: - POPUP
            if $showingModal.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    
                    //Modal
                    VStack(spacing: 0) {
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(.white)
                        Spacer()
                        //MESSAGE
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            Text("You are Broke! No more coins for you.\nLet's Play Again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .layoutPriority(1)
                            Button(action: {
                                self.showingModal = false
                                self.animatingModal = false
                                self.bet10 = true
                                self.bet20 = false
                                self.coins = 100
                            }) {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                    )
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear(perform: {
                        self.animatingModal = true
                    })
                }
            }
            
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
