import SwiftUI

struct ContentView: View {
    // AppStorage - שמירת שם המשתמש במכשיר כדי שלא יצטרך להזין אותו שוב בכניסות הבאות
    @AppStorage("userName") var userName: String = ""
    @State private var typedName: String = ""
    
    // אובייקט שמנהל את הרשאות וקבלת מיקום המשתמש מה-GPS
    @StateObject private var locationManager = LocationManager()
    
    let midPoint = 34.817549168324334
    
    // חישוב מיקום המשתמש (מזרח/מערב) בהתאם לקו האורך הנוכחי שלו לעומת נקודת האמצע
    var isEastSide: Bool {
        guard let lon = locationManager.userLongitude else { return false }
        return lon > midPoint
    }
    
    var isWestSide: Bool {
        guard let lon = locationManager.userLongitude else { return false }
        return lon <= midPoint
    }
    
    // לוגיקה שמוודאת שהוזן שם ושנתוני המיקום התקבלו לפני שמאפשרים להתחיל במשחק
    var canStart: Bool {
        return !userName.isEmpty && locationManager.isLocationReady
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                if userName.isEmpty {
                    VStack(spacing: 15) {
                        TextField("Insert name", text: $typedName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 50)
                        
                        if !typedName.isEmpty {
                            Button("Save") {
                                userName = typedName
                            }
                        }
                    }
                } else {
                    Text("Hi \(userName)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                HStack {
                    VStack {
                        Image("earth_west")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 200)
                            // שינוי שקיפות התמונה בהתאם למיקום שחושב
                            .opacity(locationManager.isLocationReady && isEastSide ? 0.2 : 1.0)
                        
                        Text(locationManager.isLocationReady && isWestSide ? "West Side (You)" : "West Side")
                            .fontWeight(locationManager.isLocationReady && isWestSide ? .bold : .regular)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image("earth_east")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 200)
                            .opacity(locationManager.isLocationReady && isWestSide ? 0.2 : 1.0)
                        
                        Text(locationManager.isLocationReady && isEastSide ? "East Side (You)" : "East Side")
                            .fontWeight(locationManager.isLocationReady && isEastSide ? .bold : .regular)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                if canStart {
                    // מעבר למסך המשחק תוך העברת הנתונים שנאספו (שם ומיקום יחסי)
                    NavigationLink(destination: GameView(userName: userName, isUserEastSide: isEastSide)) {
                        Text("START")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(width: 150, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Text("Waiting for name and location...")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
