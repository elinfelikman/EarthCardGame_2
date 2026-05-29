import SwiftUI

struct PlayingCard {
    var imageName: String
    var value: Int
}

struct GameView: View {
    var userName: String
    var isUserEastSide: Bool
    
    @State private var userScore = 0
    @State private var pcScore = 0
    @State private var currentRound = 1
    
    @State private var isFlipped = false
    @State private var userCard: PlayingCard? = nil
    @State private var pcCard: PlayingCard? = nil
    @State private var isGameOver = false
    
    // משתנה שמאזין למצב האפליקציה (האם היא פתוחה על המסך או ברקע)
    @Environment(\.scenePhase) var scenePhase
    @State private var isPaused = false
    
    let deck = [
        PlayingCard(imageName: "2", value: 2),
        PlayingCard(imageName: "3", value: 3),
        PlayingCard(imageName: "4", value: 4),
        PlayingCard(imageName: "5", value: 5),
        PlayingCard(imageName: "6", value: 6),
        PlayingCard(imageName: "7", value: 7),
        PlayingCard(imageName: "8", value: 8),
        PlayingCard(imageName: "9", value: 9),
        PlayingCard(imageName: "10", value: 10),
        PlayingCard(imageName: "prince", value: 11),
        PlayingCard(imageName: "queen", value: 12),
        PlayingCard(imageName: "king", value: 13),
        PlayingCard(imageName: "as", value: 14)
    ]
    
    var body: some View {
        VStack {
            Text("Round \(min(currentRound, 10))/10")
                .font(.headline)
                .padding(.top, 20)
            
            Spacer()
            
            HStack {
                VStack {
                    Text(isUserEastSide ? "PC" : userName)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("\(isUserEastSide ? pcScore : userScore)")
                        .font(.system(size: 50, weight: .bold))
                }
                
                Spacer()
                
                VStack {
                    Text(isUserEastSide ? userName : "PC")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("\(isUserEastSide ? userScore : pcScore)")
                        .font(.system(size: 50, weight: .bold))
                }
            }
            .padding(.horizontal, 50)
            
            Spacer()
            
            HStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isFlipped ? Color.white : Color.gray.opacity(0.4))
                        .frame(width: 120, height: 180)
                        .shadow(radius: isFlipped ? 5 : 0)
                    
                    if isFlipped, let leftCard = (isUserEastSide ? pcCard : userCard) {
                        Image(leftCard.imageName)
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                    } else {
                        Text("?")
                            .font(.largeTitle)
                    }
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isFlipped ? Color.white : Color.gray.opacity(0.4))
                        .frame(width: 120, height: 180)
                        .shadow(radius: isFlipped ? 5 : 0)
                    
                    if isFlipped, let rightCard = (isUserEastSide ? userCard : pcCard) {
                        Image(rightCard.imageName)
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                    } else {
                        Text("?")
                            .font(.largeTitle)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            SoundManager.instance.playBackgroundMusic()
            startGameLoop()
        }
        // ניהול מחזור חיים (LifeCycle): עצירה והמשך של המשחק והמוזיקה בהתאם למצב המסך
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                isPaused = false
                SoundManager.instance.resumeBackgroundMusic()
            } else if newPhase == .background || newPhase == .inactive {
                isPaused = true
                SoundManager.instance.pauseBackgroundMusic()
            }
        }
        .navigationDestination(isPresented: $isGameOver) {
            SummaryView(userName: userName, userScore: userScore, pcScore: pcScore)
        }
    }
    
    // פונקציה רקורסיבית המנהלת את רצף הסיבובים במשחק
    private func startGameLoop() {
        guard currentRound <= 10 else { return }
        
        if isPaused {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                startGameLoop()
            }
            return
        }
        
        // שליפת קלפים אקראיים לשני הצדדים
        userCard = deck.randomElement()
        pcCard = deck.randomElement()
        
        isFlipped = true
        SoundManager.instance.playFlipSound()
        
        // בדיקת המנצח בסיבוב הנוכחי והענקת נקודה
        if let uCard = userCard, let pCard = pcCard {
            if uCard.value > pCard.value {
                userScore += 1
            } else if pCard.value > uCard.value {
                pcScore += 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.isPaused {
                self.waitForResume()
                return
            }
            
            isFlipped = false
            
            // בדיקה האם הגענו לסוף המשחק (10 סיבובים) או שממשיכים לסיבוב הבא
            if currentRound == 10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    SoundManager.instance.pauseBackgroundMusic()
                    SoundManager.instance.playWinSound()
                    isGameOver = true
                }
            } else {
                currentRound += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    startGameLoop()
                }
            }
        }
    }
    
    // פונקציית עזר הממתינה לחזרת המשתמש לאפליקציה כדי להמשיך את המשחק
    private func waitForResume() {
        if isPaused {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.waitForResume()
            }
        } else {
            isFlipped = false
            if currentRound == 10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    SoundManager.instance.pauseBackgroundMusic()
                    SoundManager.instance.playWinSound()
                    isGameOver = true
                }
            } else {
                currentRound += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    startGameLoop()
                }
            }
        }
    }
}

#Preview {
    GameView(userName: "elin", isUserEastSide: false)
}
