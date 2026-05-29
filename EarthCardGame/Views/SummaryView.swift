import SwiftUI

struct SummaryView: View {
    var userName: String
    var userScore: Int
    var pcScore: Int
    
    // בודקים מי המנצח כדי להציג את השם שלו
    var winnerName: String {
        if userScore > pcScore {
            return userName
        } else if pcScore > userScore {
            return "PC"
        } else {
            return "Tie"
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // כותרת הניצחון
            Text(winnerName == "Tie" ? "IT'S A TIE!" : "\(winnerName) WINS!")
                .font(.system(size: 40, weight: .heavy))
                .foregroundColor(.primary) // מתאים אוטומטית ללילה/יום
            
            // תצוגת הניקוד הסופי
            HStack(spacing: 50) {
                VStack {
                    Text(userName)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("\(userScore)")
                        .font(.system(size: 60, weight: .bold))
                }
                
                VStack {
                    Text("PC")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("\(pcScore)")
                        .font(.system(size: 60, weight: .bold))
                }
            }
            .foregroundColor(.primary)
            
            Spacer()
            
            // כפתור חזרה לתפריט הראשי
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                Text("BACK TO MENU")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            
            Spacer()
        }
        // מסתירים את כפתור החזרה הדיפולטיבי (כדי שהמשתמש לא יוכל לחזור אחורה למשחק שהסתיים)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    // נתונים פיקטיביים רק בשביל התצוגה המקדימה
    SummaryView(userName: "elin", userScore: 7, pcScore: 3)
}
