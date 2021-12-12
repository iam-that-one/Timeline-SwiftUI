//
//  ContentView.swift
//  LoginByFireBase2
//
//  Created by Abdullah Alnutayfi on 26/01/2021.
//

import SwiftUI
import UserNotifications

struct Home: View {
    @AppStorage("isNotificationSet") var isNotificationSet: Bool = true

    init() {
       // if isNotificationSet == true{
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge,.sound]) { (success, error) in
                    if success{
                        print("All set")
                    }else if let error = error{
                        print(error.localizedDescription)
                    }
                }
       // }
       // UserDefaults.standard.set(false, forKey: "isNotificationSet")
    }
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        NavigationView{
            if isLoggedIn == true{
                HomeScreen()
            }
            else{
                LoginView()
            }
           
        }.navigationBarHidden(true)
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
