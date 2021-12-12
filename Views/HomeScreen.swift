//
//  HomeScreen.swift
//  LoginByFireBase2
//
//  Created by Abdullah Alnutayfi on 27/01/2021.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftyJSON
struct HomeScreen: View {
    @State var test = false
   
    @StateObject var vm = ViewModel()
    init() {
        UITabBar.appearance().barTintColor = .white
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        }
    
    @State var selection = 1
    var body: some View {
        
        //   NavigationView{
        TabView(selection: $selection){
            
            TimeLine()
                .tag(1)
                .tabItem {
                    Image(systemName: "house.fill")
                        .background(Color.black)
                    
                }
            search()
                .tag(3)
                .tabItem{
                    Image(systemName: "magnifyingglass")
                }
            
            AddPostView(moveToAddPostView:  $test)
                .tag(2)
                .tabItem {
                    Image(systemName: "plus.app.fill")
                    
                }
            Favourite()
                .tag(4)
                .tabItem{
                    Image(systemName: "bag.fill")
                }
            ProfileView(prImage: Data())
                .tag(0)
                .tabItem {
                    
                    Image(systemName: "person.fill")
                }
        }.accentColor(.black)
        //  }
        .ignoresSafeArea(.all)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

struct ProfileView : View {
    var gridItemLayot = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
 @State private var isshown = false
    @State var offset : CGFloat?
    @State var moveToAddPostView = false
    
    @StateObject var vm = ViewModel()
    @StateObject var vm2 = Add()
    @State private var moveToLoginView = false
    @State var logutSuccessfully = false
    @State var showEditeProfilrSheet = false
    @State var showEditName = false
    @State var edit = false
    @State var edited = false
    @State var editName = ""
    
    @State var editemail = false
    @State var editeemail = false
    @State var editemailfield = ""
    
    
    @State var editweb = false
    @State var editedweb = false
    @State var editwebfield = ""
    
    @State var editBio = false
    @State var editedBio = false
    @State var editBioField = ""
    @State var updateAlert = false
    @State var message = ""
    
    @State var showMessage = false
    @State private var showPeofileMeneu = false
    @State private var goToPosts = false
    @State private var goToSinglePost = false
    @State var prImage : Data
    @Environment(\.presentationMode) var presentationMode
    
    @State var image = UIImage()
    @State var name = ""
    @State var pushedcaption = ""
    @State var pushedPostID = ""
    @State var pushedURL = ""
    @State var pushedStatus = false
    
    var body: some View{
        ZStack(alignment: .bottom){
        VStack{
           
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: 90)
                .foregroundColor(Color(.white))
                //.ignoresSafeArea(edges: .top)
                .overlay(
                    HStack{
                        //Spacer()
                        
                        ForEach(vm.users) { user in
                            
                            if user.id == Auth.auth().currentUser?.uid{
                                HStack{
                                    Text(user.email)
                                    .fontWeight(.bold)
                                    .padding(.leading)
                                    
                                    Text("⌄")
                                        .fontWeight(.bold)
                                        .padding(.leading, -5)
                                       
                                }
                            }
                            
                        }
                        
                        Spacer()
                     /*
                        Button(action:{
                            
                        do
                        {
                            try Auth.auth().signOut()
                                
                        }
                            catch{
                                print("Error in signing out")
                            }
                            // logutSuccessfully = true
                            moveToLoginView.toggle()
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                            NotificationCenter.default.post(name: NSNotification.Name("isLoggedIn"), object: nil)
                            
                        }){
                            Text("logout")
                                .fontWeight(.bold).foregroundColor(.blue).padding()
                                .offset(y:10)
                        }
                        */
                        Button(action:{
                            withAnimation(){
                            isshown.toggle()
                                
                            offset = 0
                            }
                        }){
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing)
                                .rotationEffect(isshown ? .degrees(45) : .degrees(0))
                                .offset(y: isshown ? 5 : 0)
                        }
                        Button(action:{showPeofileMeneu.toggle()}){
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 25,height: 15)
                                .padding(.trailing)
                        }.actionSheet(isPresented: $showPeofileMeneu){
                            ActionSheet(title: Text("Settings"), message: nil, buttons: [.default(Text("loguot")){
                                do
                                {
                                    try Auth.auth().signOut()
                                        
                                }
                                    catch{
                                        print("Error in signing out")
                                    }
                                    // logutSuccessfully = true
                                    moveToLoginView.toggle()
                                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                                    NotificationCenter.default.post(name: NSNotification.Name("isLoggedIn"), object: nil)
                            },.default(Text("Delete account")){
                                //////////
                                
                                let user = Auth.auth().currentUser
                                user?.delete(completion: { (error) in
                                    if error != nil{
                                        print("Error")
                                    }
                                    else{
                                        print("success")
                                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                                        NotificationCenter.default.post(name: NSNotification.Name("isLoggedIn"), object: nil)
                                        showMessage.toggle()
                                        presentationMode.wrappedValue.dismiss()
                                       
                                    }
                                })
                                
                                ///////////
                            }
                            ,.cancel()])
                        }.alert(isPresented: $showMessage, content: {
                            Alert(title: Text("Message"), message: Text(" Account has been deleted successfully"), dismissButton: .default(Text("Ok")){})
                        })
                    } .offset(y:30)
                )
            Divider()
               
            ScrollView{
                
                
                
                // Spacer()
                
                ForEach(vm.users) { user in
                    
                    if user.id == Auth.auth().currentUser?.uid{
                        
                        HStack(spacing: 20){
                        
                            Image(uiImage: UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage())
                                .resizable()
                                .frame(width: 90, height: 70)
                                .clipShape(Circle())
                                .overlay(Circle().foregroundColor(Color(isshown ? .black : .clear)).opacity(0.60))
                                .padding(.leading,5)
                                
                       
                            VStack{
                                Text("12")
                                Text("Posts")
                                    .frame(width:50)
                            }
                            VStack{
                                Text("306")
                                Text("Followers")
                                    .frame(width:70)
                            }
                            VStack{
                                Text("308")
                                Text("Following")
                                    .frame(width:70)
                            }
                            Spacer()
                        } .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .font(Font.system(size: 16))
                        HStack{
                        VStack(alignment: .leading){
                            Text(user.displayedName)
                                .fontWeight(.bold)
                           
                        }
                            Spacer()
                        }.padding(.leading)
                        HStack{
                            VStack(alignment: .leading){
                                Text(user.bio).lineLimit(nil).padding(.leading).padding(.top)
                                Link(user.website,destination: URL(string : user.website)!)
                                    .disabled(isshown ? true : false)
                                    .foregroundColor(isshown ? Color.black : Color.blue)
                                    // .position(x:130,y: 0)
                                    .padding(.leading)
                                
                            }
                            Spacer()
                        }.padding(.leading).offset(x: -10, y: -10)
                    }
                }
                Spacer()
                    .onAppear(){
                        vm.fetchData()
                    }
                
                Button(action:{showEditeProfilrSheet.toggle()}){
                    Text("Edit profile")
                        .frame(width: UIScreen.main.bounds.width - 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.black)
                        .padding(3)
                        .border(isshown ? Color.black.opacity(0.60) : Color(.systemGray4))
                }.disabled(isshown ? true : false)
                .sheet(isPresented: $showEditeProfilrSheet, content: {
                    EditProfile(showEditeProfilrSheet: $showEditeProfilrSheet, profileImage: Image(""))
                })
                Spacer()
                ScrollView{
                 
                    LazyVGrid(columns: gridItemLayot,spacing: 1.50){
                       
                        ForEach(vm2.posts.sorted(by: {$0.date ?? Date()  < $1.date ?? Date()}).reversed(), id:\.postID){ post in
                         
                            if post.id == Auth.auth().currentUser?.uid{
                              //  withAnimation{
                                NavigationLink(destination: MyPostsView(ReciveImage:image,RecivePrImage: prImage,RecivedName: name,RecivedCaption: pushedcaption,RecivedPostID : pushedPostID,RecivePostIImage: image, RecivedURL: pushedURL, RecivedStatus: pushedStatus), isActive: $goToPosts){
                                
                            Image(uiImage:post.image ?? UIImage())
                                .resizable()
                                .frame(width: 120, height: 120)
                                .font(.system(size: 30))
                                .padding(.bottom,1)
                                .onTapGesture{
                                    image = post.image
                                    pushedPostID = post.postID ?? ""
                                    pushedcaption = post.caption
                                    pushedURL = post.imageDownloadURL ?? ""
                                    pushedStatus = post.edited ?? false
                                    goToPosts.toggle()
                                    for i in vm.users{
                                        if i.id == Auth.auth().currentUser?.uid{
                                            prImage = i.image
                                            name = i.displayedName
                                            
                                        }
                                    }
                                    }
                                   // caption = post.caption
                                    //goToSinglePost.toggle()
                                } //.transition(.move(edge: .bottom)).animation(
                                    // Animation.easeOut
                                      // .delay(0.50)
                               //)
                                //.sheet(isPresented: $goToSinglePost){
                                   // Text("Single")
                                //}
                                    
                               .gesture(LongPressGesture(minimumDuration: 2)
                                .onEnded { _ in
                                    print("tabbed for 2 sec")
                                    image = post.image
                                    pushedPostID = post.postID ?? ""
                                    pushedcaption = post.caption
                                    pushedURL = post.imageDownloadURL ?? ""
                          
                                    goToPosts.toggle()
                                    for i in vm.users{
                                        if i.id == Auth.auth().currentUser?.uid{
                                            prImage = i.image
                                            name = i.displayedName
                                            
                                        }
                                        
                                    }
                             
                                 
                                })
                              
                                    
                              //  .id(post)
                              //  }
                               
                             // .cornerRadius(5)
                          //  .shadow(color: Color.yellow ,radius: 7)
                            
                            }
                            
                            
                        }
                    }.padding(5)
                    
                }.onAppear(){}
                
                NavigationLink(destination: LoginView(), isActive: $moveToLoginView){
                    Text("")
                    
                }.hidden()
            }.navigationBarTitle(Text("Profile"),displayMode: .inline)
            .navigationBarHidden(true)
            .frame(height: 600)
            
        }.ignoresSafeArea()
        .background(isshown ? Color.black.opacity(0.60) : Color.clear)
        
            VStack{
            if isshown == true {
                Rectangle().animation(.easeIn)
                .frame(width: UIScreen.main.bounds.width, height: 400)
                .foregroundColor(.white)
                .cornerRadius(20)
                    .shadow(color:.gray ,radius: 5)
                    .overlay(VStack{
                        Text("|")
                            .font(Font.system(size: 24, weight: .bold))
                            .foregroundColor(Color(.systemGray3))
                            .rotationEffect(.degrees(90))
                        Text("Create")
                            .fontWeight(.bold)
                        Divider()
                        Group{
                            HStack{
                                Image(systemName: "squareshape.split.3x3")
                                Text("Post")
                                Spacer()
                            }.padding(.leading)
                            .onTapGesture {
                                moveToAddPostView.toggle()
                            }.sheet(isPresented: $moveToAddPostView){
                                AddPostView(moveToAddPostView:  $moveToAddPostView)
                            }
                            Divider()
                            HStack{
                                Image(systemName: "circle.dashed")
                                Text("Story")
                                Spacer()
                            }.padding(.leading)
                        }
                        
                        Spacer()
                    })
                    .offset(y: isshown ? self.offset ?? 0.0 : self.offset ?? 0.0 + 400)
                    .transition(.move(edge: .bottom))
                    .animation(
                        isshown ?  Animation.easeIn : Animation.easeOut
                            .delay(0.50)
                    )
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onEnded({ value in
                                    if value.translation.height > 0 {
                                    withAnimation{
                                    isshown = false
                                    }
                                    }
                                }))
                  
            }
            }
        }.onTapGesture {
            withAnimation{
            isshown = false
            }
        }
       
    }
    func emailUpdate(){
        
        
    }
    
}

struct MyPostsView : View{
    @State var ReciveImage : UIImage
    @State var RecivePrImage : Data
    @State var RecivedName : String
    @State var RecivedCaption : String
    @State var RecivedPostID : String
    @State var RecivePostIImage : UIImage
    @State var RecivedURL : String
    @State var RecivedStatus : Bool
    
    @StateObject var vm2 = Add()
    @StateObject var vm = ViewModel()
    @State private var showActionSheet = false
    @State private var showSheet = false
    @State private var stillLoding = false
    @State private var editCaption = "..."
    @State private var edited = false
    @State private var ToBeUpdatedPostID = ""
    @State private var ToBeDeletededPostID = ""
    @State private var ToBeDeletededURL = ""
    @State private var showEditedPostImage = UIImage()
    
    var body: some View{
        VStack{
         
        ScrollView(showsIndicators: false){
            HStack{
            Image(uiImage: (UIImage(data: RecivePrImage) ?? UIImage(named: "person")) ?? UIImage())
                .resizable()
                .frame(width: 60, height: 50)
                .clipShape(Circle())
                .padding(2)
                .overlay(Circle().stroke(Color.orange,lineWidth: 1))
                Text(RecivedName)
                Spacer()
                Button(action:{
                    showEditedPostImage = RecivePostIImage
                    editCaption = RecivedCaption
                    ToBeUpdatedPostID = RecivedPostID
                    ToBeDeletededPostID = RecivedPostID
                    ToBeDeletededURL = RecivedURL
                        showActionSheet.toggle()
                }){
                    Text("...")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.trailing,5)
                }
            }
           
            Image(uiImage:(ReciveImage))
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.black)
            HStack{
                Image(systemName: "heart")
                Image(systemName: "bubble.left")
                Image(systemName: "paperplane")
                Spacer()
                Image(systemName: "bookmark")
            }.padding(5)
        
            HStack{
                VStack(alignment: .leading){
            Text(RecivedName)
                .fontWeight(.bold)
            Text(RecivedCaption)
                .padding(.top,1)
                .padding(.bottom,0)
                    Text(RecivedStatus == true ? "Edited" : "")
                }.padding(.leading,5)
               
            Spacer()
            }.padding(.vertical,5)
            
          //  Rectangle()
               // .frame(width: UIScreen.main.bounds.width, height: 90)
               // .foregroundColor(Color(.gray))
            ForEach(vm.users){user in
                ForEach(vm2.posts.sorted(by: {$0.date ?? Date()  < $1.date ?? Date()}).reversed(), id:\.postID){ post in
                if user.id == Auth.auth().currentUser?.uid{
                    if post.id == Auth.auth().currentUser?.uid && post.postID ?? "" != RecivedPostID{
                    HStack{
                       
                        Image(uiImage: UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage())
                            .resizable()
                            .frame(width: 60, height: 50)
                            .clipShape(Circle())
                            .padding(2)
                            .overlay(Circle().stroke(Color.orange,lineWidth: 1))
                     
                    Text(user.displayedName)
                        Spacer()
                        Button(action:{
                            editCaption = post.caption
                        ToBeUpdatedPostID = post.postID ?? ""
                        ToBeDeletededPostID = post.postID ?? ""
                        ToBeDeletededURL = post.imageDownloadURL ?? ""
                        showEditedPostImage = post.image
                        
                        showActionSheet.toggle()
                        }){
                            Text("...")
                                .fontWeight(.bold)
                        }.padding(.trailing,5)
                        .actionSheet(isPresented: $showActionSheet, content: {
                            ActionSheet(title: Text("Edit"),message: nil, buttons:
                                            [
                                                .default(Text("Edit caption")){showSheet.toggle()},
                                                .default(Text("Delete post")){
                                                    
                                                    vm2.remove(postid: ToBeDeletededPostID, img_url: ToBeDeletededURL)
                                                    
                                                   // showSheet.toggle()
                                                  
                                                },
                                                .cancel()
                                            ]
                                            )
                        }
                        ).sheet(isPresented: $showSheet, content: {
                            ScrollView{
                            VStack{
                                Rectangle()
                                    .foregroundColor(Color.white)
                                    .frame(width: UIScreen.main.bounds.width, height: 40)
                                    .overlay(
                                        HStack(spacing: 90)
                                        {
                                            Button(action: {showSheet = false}){
                                            Text("Cancel")
                                                .foregroundColor(.black)
                                            }
                                            Text("Edit Info")
                                                .fontWeight(.bold)
                                            Button(action: {showSheet = false
                                                
                                                let ref =  Database.database().reference()
                                                ref.child("posts").child(ToBeUpdatedPostID).updateChildValues(["caption": editCaption,"edited" : true])
                                               // edited = true
                                                editCaption = ""
                                            }){
                                            Text("Done")
                                              
                                                .foregroundColor(.black)
                                            }
                                        }
                                    )
                                Image(uiImage: showEditedPostImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .background(Color.black)
                                TextEditor(text: $editCaption)
                                    .frame(width: UIScreen.main.bounds.width, height: 300)
                                Spacer()
                            }
                        }
                        })
                    }.foregroundColor(Color.black)
                  
                       
                            VStack(alignment:.leading){
                            Image(uiImage:post.image ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .background(Color.black)
                            HStack{
                                Image(systemName: "heart")
                                Image(systemName: "bubble.left")
                                Image(systemName: "paperplane")
                                Spacer()
                                Image(systemName: "bookmark")
                            }.padding(5)
                                Text(user.displayedName)
                                .fontWeight(.bold)
                                .padding(.leading,10)
                            Text(post.caption)
                                .padding(.top,1)
                                .padding(.bottom,0)
                                .padding(.leading,10)
                                Text("\(post.date ?? Date())")
                            Text(post.edited == true ? "Edited" : "")
                                    .font(.subheadline)
                                    .padding(.bottom, 5)
                                    .padding(.leading,10)
                        }
                        }
                }
            }
           
            }.navigationBarTitle(Text("Posts"),displayMode: .inline)
                .navigationBarHidden(false)
        }.onAppear{vm.fetchData()}
        //.animation(Animation.easeOut)
        .transition(.move(edge: .bottom)).animation(
            Animation.easeOut
              .delay(0.0)
       )
          //  Spacer()
        }.padding(.vertical)
       
    }
}
struct TimeLine : View {
    
    @State  var isStoryShoen = false
    @StateObject var vm = ViewModel()
    @StateObject var vm2 = Add()
    @State private var showActionSheet = false
    @State private var showSheet = false
    @State private var stillLoding = false
    @State private var editCaption = "..."
    @State private var edited = false
    @State private var ToBeUpdatedPostID = ""
    @State private var ToBeDeletededPostID = ""
    @State private var ToBeDeletededURL = ""
    @State private var showEditedPostImage = UIImage()
   
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View{
      
        ZStack{
            if stillLoding{
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1)
            }
        VStack{
            Rectangle()
                
                .frame(width: UIScreen.main.bounds.width, height: 50)
                .foregroundColor(Color(.white))
                
                //.ignoresSafeArea(edges: .top)
                .overlay(
                    
                        Image("IMG_69493")
                            .resizable().frame(width: 400, height: 70)
                            .offset(y:40) // No x
                      
                )
                .offset(y: -50) //50
            
           
            
            ScrollView(showsIndicators: false){
                ScrollView(.horizontal,showsIndicators: false){
                    HStack(spacing: 20){
                        ForEach(vm.users) { user in
                            if user.id == Auth.auth().currentUser?.uid{
                                VStack{
                                    Image(uiImage: UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage())
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 85, height: 65)
                                       // .padding(2)
                                        .overlay(
                                            Image(systemName: "plus.circle.fill")
                                                .frame(width: 20, height: 20)
                                                .background(Color.white)
                                                .foregroundColor(.blue)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white,lineWidth: 3))
                                                .offset(x: 30,y:20)
                                        )
                                        
                                    Text("Your Story")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .padding(.leading)
                                }
                                
                            }
                        }
                        
                        ForEach(1..<13) { i in
                            VStack{
                                
                                Image("\(i)")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .padding(3)
                                    .overlay(Circle().stroke(Color.orange,lineWidth: 2))
                                    .padding(.top,2).padding(.bottom,2)
                                    .onTapGesture{
                                       // withAnimation{
                                        isStoryShoen.toggle()
                                   // }
                                    }
                                Text("user \(i)")
                                    .font(.caption)
                                    .offset(y:-4)
                               
                            }
                        }
                        
                    }
                }.padding(.bottom)
                .onAppear(){
                    vm.fetchData()
                }
                Divider()
                    .offset(y: -15)
              
                    ForEach(vm2.posts.sorted(by: {$0.date ?? Date()  < $1.date ?? Date()}).reversed(),id :\.postID){ post in
                        ForEach(vm.users){ user in
                       // print(post.date ?? Date())
                        if post.id == user.id {
                           
                    VStack(alignment:.leading){
                        HStack{
                           
                            Image(uiImage: UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage())
                                .resizable()
                                .frame(width: 60, height: 50)
                                .clipShape(Circle())
                                .padding(2)
                                .overlay(Circle().stroke(Color.orange,lineWidth: 1))
                         
                                .onTapGesture{print(post.date ?? Date())}
                            
                        Text(user.displayedName)
                          
                            Spacer()
                            Button(action:{
                                print(user.id  + " " + post.caption)
                                    editCaption = post.caption
                                ToBeUpdatedPostID = post.postID ?? ""
                                ToBeDeletededPostID = post.postID ?? ""
                                ToBeDeletededURL = post.imageDownloadURL ?? ""
                                showEditedPostImage = post.image
                                
                                showActionSheet.toggle()
                            }){
                              //  Image("3dots")
                                   // .resizable()
                                   // .frame(width: 25, height: 20)
                                   // .foregroundColor(.black)
                                Text(post.id == Auth.auth().currentUser?.uid ? "..." : "")
                                    .fontWeight(.bold)
                            }.actionSheet(isPresented: $showActionSheet, content: {
                                ActionSheet(title: Text("Edit"),message: nil, buttons:
                                                [
                                                    .default(Text("Edit caption")){showSheet.toggle()},
                                                    .default(Text("Delete post")){
                                                        
                                                        vm2.remove(postid: ToBeDeletededPostID, img_url: ToBeDeletededURL)
                                                        
                                                       // showSheet.toggle()
                                                      
                                                    },
                                                    .cancel()
                                                ]
                                                )
                            }
                            ).sheet(isPresented: $showSheet, content: {
                                ScrollView{
                                VStack{
                                    Rectangle()
                                        .foregroundColor(Color.white)
                                        .frame(width: UIScreen.main.bounds.width, height: 40)
                                        .overlay(
                                            HStack(spacing: 90)
                                            {
                                                Button(action: {showSheet = false}){
                                                Text("Cancel")
                                                    .foregroundColor(.black)
                                                }
                                                Text("Edit Info")
                                                    .fontWeight(.bold)
                                                Button(action: {showSheet = false
                                                    
                                                    let ref =  Database.database().reference()
                                                    ref.child("posts").child(ToBeUpdatedPostID).updateChildValues(["caption": editCaption,"edited" : true])
                                                   // edited = true
                                                    editCaption = ""
                                                }){
                                                Text("Done")
                                                  
                                                    .foregroundColor(.black)
                                                }
                                            }
                                        )
                                    Image(uiImage: showEditedPostImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .background(Color.black)
                                    TextEditor(text: $editCaption)
                                        .frame(width: UIScreen.main.bounds.width, height: 300)
                                    Spacer()
                                }
                            }
                            })
                        }
                       
                            .padding(.trailing)
                        Text("Location")
                            .foregroundColor(.gray)
                            .padding(.leading)
                        }.padding(.vertical,5)
              
         
                    VStack(alignment:.leading){
                    Image(uiImage:post.image ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .background(Color.black)
                      
                    HStack{
                        Button(action:{
                            let ref =  Database.database().reference()
                            ref.child("posts").child(post.postID ?? "").updateChildValues(["NumberOfLikes": post.NumberOfLikes! + 1 ])
                            
                            // ToDo :- Add user ids to an arry in the database to know how likes the post.
                            
                        }){
                            Image(systemName: "heart")
                        }
                        Image(systemName: "bubble.left")
                        Image(systemName: "paperplane")
                        Spacer()
                        Image(systemName: "bookmark")
                    }.padding(5)
                        Text(user.displayedName)
                        .fontWeight(.bold)
                        .padding(.leading,10)
                    Text(post.caption)
                        .padding(.leading,10)
                        Text(post.edited == true ? "Edited" : "")
                            //////////////////////////////////////
                            .font(.subheadline)
                            .padding(.leading,10)
                }
                }
                    }
                
                    }
            }
            
         
            // .padding()
            //.onAppear(){vm.fetchData()}
            .navigationBarHidden(true)
            .frame(height: 620)
            //.offset(y: -20)
        }.ignoresSafeArea()
        
            VStack{
            if isStoryShoen == true{
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .onTapGesture{
                        //withAnimation{
                        isStoryShoen.toggle()
                       // }
                    }
                    .transition(.move(edge: .bottom)).animation(
                        Animation.easeOut
                          .delay(0.0)
                   )
            }
            }
            
        }.onAppear{
            load()
        }
        .ignoresSafeArea()
    }
    func load(){
        stillLoding = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 4){
            stillLoding = false
        }
    }
}
struct StoryView : View{
   // @Environment(\.presentationMode) var presentationMode
  //  @Binding var isStoryShoen : Bool
    var body: some View{
        VStack{
        Rectangle()
        frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
          //  .onTapGesture {
              //  withAnimation(){
                    //presentationMode.wrappedValue.dismiss()
                   // isStoryShoen.toggle()
               // }
           // }
        }.navigationBarHidden(true)
        .ignoresSafeArea()
    }
}
struct AddPostView : View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var moveToAddPostView : Bool
    @State var postImage : Image?
    @State var PickedImage = UIImage()
    @State var showActionSheet = false
    @State var showImagePicker = false
    @State var sourceType:UIImagePickerController.SourceType = .camera
    @StateObject var vm = ViewModel()
  //  @StateObject var vm2 = Post(image: UIImage(), caption: "")
    @State var isActive = false
   // init(){
 
      //  UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

   // }
    @State var caption = ""
    @State var imageDownloadURL : String?
    
   
    var body: some View{
        ScrollView{
            VStack(alignment: .leading){
           
            ForEach(vm.users) { user in
                if Auth.auth().currentUser?.uid == user.id{
                    VStack{
                        Text("New post")
                            .font(.headline)
                    if postImage != nil{
                        postImage!
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .foregroundColor(.green)
                            
                    }
                    else{
            Image("empty")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width - 20)
                .scaledToFit()
                .opacity(0.30)
                    }
                    }
                .onTapGesture {
                    showActionSheet.toggle()
                    self.hideKeyboard()
                }.actionSheet(isPresented: $showActionSheet, content: {
                    ActionSheet(title: Text("choose a photo"), message: nil, buttons:
                                    [
                                        .default(Text("camera")){sourceType = .camera;showImagePicker.toggle()},
                                        .default(Text("Photo library")){sourceType = .photoLibrary; showImagePicker.toggle()},
                                        .cancel(){}
                                    ]
                    )
                    }).sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                        ImagePicker(sourceType: sourceType, selectedImage: $PickedImage)
                }
                    
                    Text(user.displayedName + ", ID: " + user.email)
                 
                    .padding(.leading)
                        .onTapGesture {
                            
                        self.hideKeyboard()
                    }
                       
                    
                 Rectangle()
                    .fill(Color.white)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 200)
                    .overlay(TextEditor(text: $caption)
                                .frame(width: 350, height: 200)
                                .border(Color.gray)
                             .padding())
                    .padding(.leading,10)
 
                }
            }
            Button(action:{
                if caption != "" && PickedImage != UIImage(){
                    let newPost = Post(image: PickedImage, caption: caption)
                    newPost.uploadPost()
                    presentationMode.wrappedValue.dismiss()
                    
                }
                moveToAddPostView = false
            }){
                HStack{
                    Spacer()
                Text("Share")
                    .fontWeight(.bold)
                    .frame(width: 70, height: 30)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding()
                   
                    Spacer()
            }
                
            }
            
        }.navigationBarHidden(true)                                                                                                                                                                                                                                                                                                                                                                      
           
        .onAppear(){
            vm.fetchData()
        }
        }
       
    }
    func loadImage()
    {
        postImage = Image(uiImage: PickedImage)
        
        }
    func convertImage(_ image : UIImage) -> Data{
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {return Data()}
        return imageData
    }

        
    }


struct Favourite : View {
    var body: some View{
        Text("Favourite")
    }
}

struct search : View{
    @StateObject var vm = ViewModel()
    @State var search = ""

    var body: some View{
        VStack{
            Group{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .overlay(  HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.systemGray3))
            TextField("Search", text: $search)
                    Button(action: {search = ""
                        self.hideKeyboard()
                    }){
                        if search != ""{
                        Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color(.systemGray3))
                                    .frame(width: 20, height: 20)
                        
                        }
                    }
                }.padding())
        } .padding(.bottom)
            .frame(width: 300, height: 60, alignment: .center)
            .cornerRadius(5)
            .shadow(radius: 5)
            ScrollView(showsIndicators: false) {
                ForEach(vm.users.filter({$0.displayedName.lowercased().contains(search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())})) { user in
                    HStack{
                        Image(uiImage: UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage())
                            .resizable()
                            .frame(width: 70, height: 50)
                            .clipShape(Circle())
                        NavigationLink(destination: SearchProfileView(id: user.id))
                        {
                        VStack(alignment: .leading){
                            Text(user.displayedName)
                            Text(user.email)
                                .font(.caption)
                        }
                        }
                     
                        Spacer()
                    
                    }
            }
            }.onAppear{vm.fetchData()}
      //.border(Color.gray)
    
        Spacer()
        }.navigationBarHidden(true)
       
        .padding()
    }
}


struct SearchProfileView : View {
    @State var id : String
    var gridItemLayot = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    @StateObject var vm = ViewModel()
    @StateObject var vm2 = Add()
    var body: some View{
        ScrollView{
        ForEach(vm.users) { user in
            if user.id == id{
              
                HStack{
                    Image(uiImage: UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage())
                        .resizable()
                        .frame(width: 90, height: 70)
                        .clipShape(Circle())
                        .padding(.leading,5)
                    VStack(alignment: .leading){
                        Text(user.displayedName)
                        
                        Text(user.email)
                            .font(Font.system(size: 10))
                    }
                    Spacer()
                } .foregroundColor(.black)
                
                HStack{
                    VStack(alignment: .leading){
                        Text(user.bio).lineLimit(nil).padding(.leading).padding(.top)
                        Link(user.website,destination: URL(string : user.website)!)
                            // .position(x:130,y: 0)
                            .padding(.leading)
                        
                    }
                    Spacer()
                }.padding(.leading).offset(x: -10, y: -10)
                
                
                
      
        Spacer()
            .onAppear(){
                vm.fetchData()
            }
                
       /*
        Button(action:{showEditeProfilrSheet.toggle()}){
            Text("Edit profile")
                .frame(width: UIScreen.main.bounds.width - 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.black)
                .padding(3)
                .border(Color(.systemGray5))
        }.sheet(isPresented: $showEditeProfilrSheet, content: {
            EditProfile(showEditeProfilrSheet: $showEditeProfilrSheet, profileImage: Image(""))
        })
             */
        
        Spacer()
        
      
         
            .navigationBarTitle(Text(user.email),displayMode:.inline)
        }
            Spacer()
            
                
        
            }
            
            LazyVGrid(columns: gridItemLayot,spacing: 1){
                ForEach(vm2.posts, id: \.imageDownloadURL){ post in
                    if post.id == id{
                    Image(uiImage:post.image ?? UIImage())
                        .resizable()
                        .frame(width: 120, height: 120)
                        .font(.system(size: 30))
                        .padding(.bottom,1)
                   
                    //  .cornerRadius(5)
                    //.shadow(color: Color.yellow ,radius: 7)
                    
                    }
                    
                }
            }.padding(5)
        }.onAppear(){vm.fetchData()}
 
        Spacer()
    }
}

struct EditProfile : View {
    @StateObject var vm = ViewModel()
    @State private var moveToLoginView = false
    @State var logutSuccessfully = false
    @Binding var showEditeProfilrSheet : Bool
    @State var showEditName = false
    @State var edit = false
    @State var edited = false
    @State var editName = ""
    
    @State var editemail = false
    @State var editedemail = false
    @State var editemailfield = ""
    
    
    @State var editweb = false
    @State var editedweb = false
    @State var editwebfield = ""
    
    @State var editBio = false
    @State var editedBio = false
    @State var editBioField = ""
    
    @State var profileImage = Image(systemName: "person")
    @State var PickedImage = UIImage()
    @State var showActionSheet = false
    @State var showImagePicker = false
    @State var sourceType:UIImagePickerController.SourceType = .camera
    
    @State var showNewImage = false
    
    @State var updateAlert = false
    @State var message = ""
    fileprivate func updateBio() -> HStack<TupleView<(Button<Text>, Button<Text>)>> {
        return HStack{
            Button("Done"){
                if editBioField == ""
                {
                    // message = "bio cannot be empty"
                    editBioField = "NULL"
                    //return
                }
                message = "Yor Bio successfully updated"
                updateAlert.toggle()
                editBio = false
                editedBio = true
                // updateAlert = true
                let newData = ["bio" : editBioField]
                let db = Firestore.firestore()
                db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid as Any).getDocuments { (result, error) in
                    if error == nil{
                        for document in result!.documents{
                            //document.setValue("1", forKey: "isolationDate")
                            db.collection("users").document(document.documentID).setData(newData , merge: true)
                        }
                    }
                }
            }
            Button("Cancel"){editBio = false}
        }
    }
    
    fileprivate func updateEmail() -> HStack<TupleView<(Button<Text>, Button<Text>)>>  {
        return HStack {
            Button("Done"){
                if editemailfield == ""
                {
                    // message = "bio cannot be empty"
                    editemailfield = "NULL"
                    //return
                }
                let newData = ["email" : editemailfield]
                let db = Firestore.firestore()
            
                message = "Yor email successfully updated"
               // updateAlert.toggle()
                editemail = false
                editedemail = true
                // updateAlert = true
                
                if editemailfield != Auth.auth().currentUser?.email{
                    Auth.auth().currentUser?.updateEmail(to: editemailfield){error in
                        if let error = error{
                            print(error)
                            message = error.localizedDescription
                            updateAlert.toggle()
                        }else{
                            db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid as Any).getDocuments { (result, error) in
                                if error == nil{
                                    for document in result!.documents{
                                       
                                        // TO DO :- // make sure email number never duplicated in database documents.
                                        
                                        // // // // // // // // // // // //
                                        db.collection("users").document(document.documentID).setData(newData , merge: true)
                                       message = "Your email successfully updated"
                                        updateAlert.toggle()
                                    }
                                }
                            }
                        }
                    }
                }
                else{
                    message = "New email must be different than current email"
                    updateAlert.toggle()
                }
                
            }
            Button("Cancel"){editemail = false}
        }
    }
    
    var body: some View{
        ScrollView{
            VStack{
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width, height: 30)
                    .overlay(
                        HStack{
                            Button(action:{
                                showEditeProfilrSheet = false
                                edit = false
                                edited = false
                                editBio = false
                                editedBio = false
                                editweb = false
                                editedweb = false
                                editemail = false
                                editedemail = false
                                
                            }){
                                Text("Cancel")
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            Text("Edit Profile")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                            Spacer()
                            Button(action:{
                                // updateAlert = true
                                edit = false
                                edited = false
                                print(editName)
                                
                                showEditeProfilrSheet = false
                                
                            }){
                                Text("Done")
                                    .foregroundColor(.blue)
                            }
                        }.padding(.horizontal).padding(.top,5)
                        
                    )
                Divider()
                
                ForEach(vm.users) { user in
                
                    if user.id == Auth.auth().currentUser?.uid{
                        if showNewImage == true{
                            HStack{
                            profileImage
                                .resizable()
                                .frame(width: 80, height: 60, alignment: .center)
                                .foregroundColor(.green)
                                .clipShape(Circle())
                                
                                Button("Done"){
                                    message = "profile image updated successfully"
                                    updateAlert.toggle()
                                    let newData = ["image" : uploadImage(PickedImage)]
                                    let db = Firestore.firestore()
                                    db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid as Any).getDocuments { (result, error) in
                                        if error == nil{
                                            for document in result!.documents{
                                                //document.setValue("1", forKey: "isolationDate")
                                                db.collection("users").document(document.documentID).setData(newData , merge: true)
                                            }
                                        }
                                    }
                                    showNewImage = false
                                   
                                }
                        }
                        }
                        else{
                        HStack{
                            Image(uiImage: UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage())
                                .resizable()
                                .frame(width: 80, height: 60)
                                .clipShape(Circle())
                                .padding(.leading)
                                .onTapGesture{
                                    // To Do :-
                                }
                        } .foregroundColor(.black)
                        }
                        Button(action:{
                            profileImage = Image(uiImage: UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage())
                            showNewImage = true
                            showActionSheet.toggle()
                            
                        }){
                            Text("Change Profile Photo")
                                .font(.caption)
                        }.actionSheet(isPresented: $showActionSheet, content: {
                            ActionSheet(title: Text("Choose a photo"), message: Text("FireBase"), buttons:
                                            [
                                                .default(Text("Camera")){showImagePicker.toggle();sourceType = .camera},
                                                .default(Text("Photo library")){showImagePicker.toggle();sourceType = .photoLibrary},
                                                .default(Text("Remove profile picture")){PickedImage = UIImage(named: "person") ?? UIImage();profileImage = Image("person") },
                                                .cancel(){ PickedImage = UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage();}
                                            ])
                        }
                        ).sheet(isPresented: $showImagePicker,onDismiss: {loadImage()
                            if PickedImage == UIImage() //هذا عشان إذا طلعت من مكتبة الصور بدون ما اختار، يصير البروفايل ايميج و البكيد ايميج فاضية
                            {
                            PickedImage = UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage()
                            profileImage = Image(uiImage: UIImage(data: user.image) ?? UIImage(named: "person") ?? UIImage())
                            }
                        }, content: {
                            ImagePicker(sourceType: sourceType, selectedImage: $PickedImage)
                        })
                        Divider()
                        HStack(spacing: 30){
                            VStack(alignment: .leading, spacing: 25){
                                Text("Name")
                                  //  .offset(y: -35)
                                Text("Username")
                                   // .offset(y: -35)
                                Text("Website")
                                  //  .offset(y: -35)
                                Text("Bio")
                                   // .offset(y: -10)
                            }//.offset(y: -20)
                            
                            VStack(alignment: .leading){
                                
                                Group{
                                    if edit == true{
                                        
                                        TextField("",text: $editName)
                                        HStack{
                                            Button("Done"){
                                                if editName == ""
                                                {
                                                    // message = "bio cannot be empty"
                                                    editName = "NULL"
                                                    //return
                                                }
                                                message = "Yor name successfully updated"
                                                edit = false
                                                edited = true
                                                updateAlert.toggle()
                                                let newData = ["displayedName" : editName]
                                                let db = Firestore.firestore()
                                                db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid as Any).getDocuments { (result, error) in
                                                    if error == nil{
                                                        for document in result!.documents{
                                                            //document.setValue("1", forKey: "isolationDate")
                                                            db.collection("users").document(document.documentID).setData(newData , merge: true)
                                                        }
                                                    }
                                                }
                                            }
                                            Button("Cancel"){
                                                edit = false
                                                edited = false
                                            }
                                        }
                                        
                                    }
                                    
                                    if edited == true{
                                        Text(editName)
                                       // edited = false
                                    }
                                    else if edit == false{
                                        Text(user.displayedName)
                                    }
                                }.onTapGesture{
                                    edit = true
                                    edited = false
                                    editName = user.displayedName
                                }.alert(isPresented: $updateAlert){
                                    Alert(title: Text("Message"), message: Text(message),dismissButton: .default(Text("Ok")))
                                }
                                
                                Divider()
                                 //Text(user.email)
                                   // .padding()
                                  
                                
                                // // // // // // // // // // // // // // // // // // // //
                              
                                Group{
                                    if editemail == true{
                                        TextEditor(text: $editemailfield)
                                            .frame(height: 50)
                                     
                                        updateEmail()
                                    
                                    }
                                    
                                    if editedemail == true{
                                        Text(editemailfield)
                                        // Link(editwebfield,destination: URL(string:user.website)!)
                                        
                                    }
                                    else if editemail == false{
                                        Text(user.email)
                                        // Link(user.website,destination: URL(string:user.website)!)
                                    }
                                    
                                }.onTapGesture{
                                    editemail = true
                                    editedemail = false
                                    editemailfield = user.email
                                }
                                 
                                // // // // // // // // // // // // // // // // // // // //
                                
                                
                                Divider()
                                //Link(user.website,destination: URL(string:user.website)!)
                                //   .offset(y: 10)
                                // // // // // // // // // // // // // // // // // // // //
                                
                                Group{
                                    if editweb == true{
                                        
                                        TextEditor(text: $editwebfield)
                                            .frame(height: 50)
                                        
                                        
                                        HStack{
                                            Button("Done"){
                                                if editwebfield == ""
                                                {
                                                    // message = "bio cannot be empty"
                                                    editwebfield = "NULL"
                                                    //return
                                                }
                                                message = "Yor website successfully updated"
                                                updateAlert.toggle()
                                                editweb = false
                                                editedweb = true
                                                // updateAlert = true
                                                let newData = ["website" : editwebfield]
                                                let db = Firestore.firestore()
                                                db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid as Any).getDocuments { (result, error) in
                                                    if error == nil{
                                                        for document in result!.documents{
                                                            //document.setValue("1", forKey: "isolationDate")
                                                            db.collection("users").document(document.documentID).setData(newData , merge: true)
                                                        }
                                                    }
                                                }
                                            }
                                            Button("Cancel"){editweb = false}
                                        }
                                    }
                                    
                                    if editedweb == true{
                                        Text(editwebfield)
                                        // Link(editwebfield,destination: URL(string:user.website)!)
                                        
                                    }
                                    else if editweb == false{
                                        Text(user.website)
                                        // Link(user.website,destination: URL(string:user.website)!)
                                    }
                                    
                                }.onTapGesture{
                                    editweb = true
                                    editedweb = false
                                    editwebfield = user.website
                                }
                                
                                // // // // // // // // // // // // // // // // // // // //
                                
                                
                                Divider()
                                //   .offset(y: 10)
                                //  Text(user.bio)
                                
                                Group{
                                    if editBio == true{
                                        
                                        TextEditor(text: $editBioField)
                                            .frame(height: 50)
                                        updateBio()
                                        
                                    }
                                    
                                    if editedBio == true{
                                        Text(editBioField)
                                    }
                                    else if editBio == false{
                                        Text(user.bio)
                                    }
                                    
                                }.onTapGesture{
                                    editBio = true
                                    editedBio = false
                                    editBioField = user.bio
                                }
                                
                            }//.padding(.leading)
                            
                            Spacer()
                        }.padding(.leading)
                        
                        Divider()
                        if edit == true{
                            HStack{
                                Text("Your name, displayed here for the first time, is taken from the name data you entered when registering. When you change this name, the data for that name will remain in your record.")
                                    .foregroundColor(Color(.systemGray3))
                                Spacer()
                            }.padding()
                        }
                        if editemail == true{
                            HStack{
                                Text("Your email must be different than the current email, and you cannot leave it empty. Email address is used to distinguish you from the others.")
                                    .foregroundColor(Color(.systemGray3))
                                Spacer()
                            }.padding()
                        }
                        
                        if editweb == true{
                            HStack{
                                Text("You should put your website here.")
                                    .foregroundColor(Color(.systemGray3))
                                Spacer()
                            }.padding()
                        }
                        
                        if editBio == true{
                            HStack{
                                Text("Describe yourself to simplify your personality for the others.")
                                    .foregroundColor(Color(.systemGray3))
                                Spacer()
                            }.padding()
                        }
                    }
                }
                Spacer()
                
            }
        }.onAppear(){vm.fetchData()}
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




#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


