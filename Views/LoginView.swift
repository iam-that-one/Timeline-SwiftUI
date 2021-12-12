//
//  LoginView.swift
//  LoginByFireBase2
//
//  Created by Abdullah Alnutayfi on 26/01/2021.
//

import SwiftUI
import Firebase
struct LoginView: View {
    @State private var email = "ccsi-iuni@hotmail.com"
    @State private var password = "Aa1234567890&"
    @State private var message = ""
    @State private var isScured = true
    @State private var showErrorAleart = false
    @State private var authunticatedUser = false
    @State private var resetPasswordSheet = false
    @State private var emailForReset = ""
    var body: some View {
        ScrollView(showsIndicators: false){
        VStack{
            NavigationLink(destination: HomeScreen(), isActive: $authunticatedUser){
                Text("")
            }.hidden()
            Spacer()
            Image("login")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            Spacer()
            VStack{
                HStack{
                    Image(systemName: "envelope")
                        .foregroundColor(Color(.systemGreen))
                        .opacity(1)
                    Divider()
                    
                 
                     
                        TextField("Email",text:$email)
                    
                
                }
                
               
                Divider()
                    .padding(10)
                HStack{
                    Image(systemName: isScured ? "lock" : "lock.open")
                        .foregroundColor(Color(.systemGreen))
                        .opacity(1)
                    Divider()
                    if isScured {
                        SecureField("Password",text:$password.animation())
                    }
                    else{
                        TextField("Password",text:$password.animation())
                    }
                    Spacer()
                    Button(action:{isScured .toggle()}){
                        Image(systemName: isScured ? "eye.fill" : "eye.slash")
                            .foregroundColor(Color(.systemGreen))
                            .opacity(1)
                    }
                }
            }.frame(width: 300, height: 100, alignment: .center)
                .modifier(TextFields())
          
            HStack{
                Button(action:{resetPasswordSheet.toggle()}){
                    Spacer()
                    Text("Forget password")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }.sheet(isPresented: $resetPasswordSheet, content: {
                    VStack{
                        HStack{
                            Spacer()
                    TextField("Your registered email", text: $emailForReset)
                        .padding()
                        .border(Color.black)
                            Spacer()
                        }
                    Button(action:{
                        if emailForReset != ""{
                            Auth.auth().sendPasswordReset(withEmail: emailForReset) { (err) in
                                if  err != nil{
                                    message = err!.localizedDescription
                                    showErrorAleart.toggle()
                                    return
                                }
                                else{
                                    message = "password reset link sent successfully to \(emailForReset). Please check your inbox or junck mails"
                                    showErrorAleart.toggle()
                                }
                                
                            }
                        }
                        else if emailForReset == "" {
                            message = "You should provide your registered email"
                            showErrorAleart.toggle()
                        }
                    }){
                        Text("Reset Password")
                        
                    }.alert(isPresented: $showErrorAleart){
                        Alert(title: Text("Message"), message: Text(message), dismissButton: .default(Text("Ok")))
                    }
                        Spacer()
                    }.padding()
                    
                })
            }.padding().offset(x:-20,y:10)
            Spacer()
            Button(action:{
                let error = fieldsValidation()
                if error != nil{
                    message = fieldsValidation()!  // the message contais the error string came from fieldsValidation function.
                    showErrorAleart.toggle()
                }
                else{
                    Auth.auth().signIn(withEmail:email.trimmingCharacters(in: .whitespacesAndNewlines), password: password) {(result, error) in
                        if error != nil{
                            message = error!.localizedDescription
                            showErrorAleart.toggle()
                            return
                        }
                        else{
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            authunticatedUser.toggle()
                        }
                    }

                }
            }){
                
                Text("log in")
                    .modifier(Buttons())
              
            }.alert(isPresented: $showErrorAleart){
                Alert(title: Text("Message"), message: Text(message), dismissButton: .default(Text("Ok")))
            }
            HStack{
            Text("New?")
                NavigationLink(destination: SignUpView())
                {
                    Text("Sign up")
                }
            }
            Spacer()
        } .navigationBarHidden(true)
    }
    }
    func fieldsValidation() -> String? {
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "you must fill all fields"
        }
        if isEmailValid(email.trimmingCharacters(in: .whitespacesAndNewlines)) == false{
            return "email is badly formatted!"
        }
        if isPasswordValid(password.trimmingCharacters(in: .whitespacesAndNewlines)) == false{
            return "please make sure your password is at least eight characters, contains a special character and a number."
        }
    return nil
    }
    func isEmailValid(_ email : String) -> Bool{
        let checkEmail = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return checkEmail.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    func isPasswordValid(_ password : String) -> Bool{
        let checkPassword = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-a\\d$@$#!%*?&]{8,}")
        return checkPassword.evaluate(with: password.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
