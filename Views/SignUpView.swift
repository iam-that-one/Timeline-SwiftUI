//
//  SignUpView.swift
//  LoginByFireBase2
//
//  Created by Abdullah Alnutayfi on 26/01/2021.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
struct SignUpView: View {
    @State private var email = ""
    @State private var password = "Aa1234567890&"
    @State private var passwordC = "Aa1234567890&"
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var isScured = true
    @State private var message = ""
    @State private var showErrorAleart = false
    @State var profileImage : Image?
    @State var PickedImage = UIImage()
    @State var showActionSheet = false
    @State var showImagePicker = false
    @State var sourceType:UIImagePickerController.SourceType = .camera
    @State var signedUpsccessfully = false
    var array = [Data]()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView(showsIndicators: false){
        ScrollView{
         
            VStack{
          
               
                if profileImage != nil{
                    profileImage!
                        .resizable()
                        .frame(width: 170, height: 170, alignment: .center)
                        .foregroundColor(.green)
                        .clipShape(Circle())
                }
                    else{
                
                Image(systemName: "person.crop.circle.fill.badge.plus")
                    
                    .resizable()
                   
                    .scaledToFit()
                    .padding()
                    .frame(width: 200, height: 190)
                    .padding()
                    .clipShape(Circle())
                    .foregroundColor(Color(.systemGreen))
                    .opacity(0.90)
                }
                }.onTapGesture {
                    showActionSheet.toggle()
                }.actionSheet(isPresented: $showActionSheet, content: {
                    ActionSheet(title: Text("Choose a photo"), message: Text("FireBase"), buttons:
                                    [
                                        .default(Text("Camera")){showImagePicker.toggle();sourceType = .camera},
                                        .default(Text("Photo library")){showImagePicker.toggle();sourceType = .photoLibrary},
                                        .cancel()
                                    ])
                }
                ).sheet(isPresented: $showImagePicker,onDismiss: loadImage, content: {
                    ImagePicker(sourceType: sourceType, selectedImage: $PickedImage)
                })
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
                            SecureField("Password",text:$password)
                        }
                        else{
                           TextField("Password",text:$password)
                        }
                        Spacer()
                        Button(action:{isScured .toggle()}){
                            Image(systemName: isScured ? "eye.fill" : "eye.slash")
                                .foregroundColor(Color(.systemGreen))
                                .opacity(1)
                        }
                        
                    }
                    Divider()
                        .padding(10)
                    HStack{
                        Image(systemName: isScured ? "lock" : "lock.open")
                            .foregroundColor(Color(.systemGreen))
                            .opacity(1)
                        Divider()
                        if isScured {
                            SecureField("Password",text:$passwordC)
                        }
                        else{
                           TextField("Password",text:$passwordC)
                        }
                        Divider()
                    }
                    Divider()
                        .padding(10)
                    Spacer()
                    HStack{
                        Image(systemName: "person")
                            .foregroundColor(Color(.systemGreen))
                            .opacity(1)
                        Divider()

                    TextField("First name", text: $firstname)
                    }
                    Divider()
                        .padding(10)
                    
                    HStack{
                        Image(systemName: "person")
                            .foregroundColor(Color(.systemGreen))
                            .opacity(1)
                        Divider()
                    TextField("Last name", text: $lastname)
                    }
                }.frame(width: 300, height: 300)
                
                    .modifier(TextFields())
                Spacer()
                Button(action:{
                   let error = fieldsValidation()
                    if error != nil{
                        message = error!
                        showErrorAleart.toggle()
                        return
                    }
                    else{
                        Auth.auth().createUser(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password.trimmingCharacters(in: .whitespacesAndNewlines)) { (result, error) in
                            
                            if error != nil{
                                message = error!.localizedDescription
                                showErrorAleart.toggle()
                            }
                            else{
                                let db = Firestore.firestore()
                                db.collection("users").addDocument(data: ["firstname" : firstname.trimmingCharacters(in: .whitespacesAndNewlines),"lastname":lastname.trimmingCharacters(in: .whitespacesAndNewlines),"email":email.trimmingCharacters(in: .whitespacesAndNewlines),"displayedName":firstname.trimmingCharacters(in: .whitespacesAndNewlines) + " " + lastname.trimmingCharacters(in: .whitespacesAndNewlines),"uid":result!.user.uid,"image": uploadImage(PickedImage),"website" : "NULL", "bio" : "NULL"])
                                    signedUpsccessfully.toggle()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }){
                    Text("Sign up")
                        .modifier(Buttons())
                  
                }.alert(isPresented: $showErrorAleart, content: {
                    Alert(title: Text("Message"), message: Text(message), dismissButton: .default(Text("Ok")))
                })
               
                HStack{
                Text("Have an account?")
                    NavigationLink(destination: LoginView())
                    {
                        Text("login")
                    }
                } .alert(isPresented: $signedUpsccessfully, content: {
                    Alert(title: Text("Message"), message: Text("signed up sccessfully"), dismissButton: .default(Text("Ok")))
                })
                Spacer()
          
            
        }.navigationBarHidden(true)
    }
    }
    func fieldsValidation() -> String?{
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordC.trimmingCharacters(in: .whitespacesAndNewlines) == "" || firstname.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastname.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please, all fields must bf filled"
        }
        if password.trimmingCharacters(in: .whitespacesAndNewlines) != passwordC.trimmingCharacters(in: .whitespacesAndNewlines){
            return "Password does not match"
        }
        if emailValidation(email.trimmingCharacters(in: .whitespaces)) == false{
            return "Email adress is badly formatted"
        }
        if passwordValidation(password.trimmingCharacters(in: .whitespacesAndNewlines)) == false{
            return "please make sure your password is at least eight characters, contains a special connector and a number."
        }
        return nil
    }
    func emailValidation(_ email : String) -> Bool{
        let checkedEmail = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return checkedEmail.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    func passwordValidation(_ password : String) -> Bool{
        let checkedPassword = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-a\\d$@$#!%*?&]{8,}")
        return checkedPassword.evaluate(with: password.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    func loadImage()
    {
        profileImage = Image(uiImage: PickedImage)
        
        }
    func uploadImage(_ image : UIImage) -> Data{
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {return Data()}
        return imageData
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
