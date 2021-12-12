//
//  ViewModel.swift
//  LoginByFireBase2
//
//  Created by Abdullah Alnutayfi on 27/01/2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase
import SwiftyJSON
class ViewModel: ObservableObject {
    @Published var users = [User]()
    
    
    private let db = Firestore.firestore()
    
    func fetchData(){
        db.collection("users").addSnapshotListener { (QuerySnapshot, error) in
            guard let document = QuerySnapshot?.documents else{
                return
            }
            self.users = document.map({ (QueryDocumentSnapshot) -> User in
                let data = QueryDocumentSnapshot.data()
                let id = data["uid"] as? String ?? ""
                let firstname = data["firstname"] as? String ?? "NO VALUE"
                let lastname = data["lastname"] as? String ?? "NO VALUE"
                let displayedName = data["displayedName"] as? String ?? "NO VALUE"
                let email = data["email"] as? String ?? "NO VALUE"
                let image = data["image"] as? Data ?? Data()
                let website = data["website"] as? String ?? "NO VALUE"
                let bio = data["bio"] as? String ?? "NO VALUE"
                
                return User(id: id,firstname: firstname, lastname: lastname,displayedName: displayedName ,email: email,image: image,website: website, bio: bio)
            })
        }
    }
}

struct User: Identifiable {
    var id : String = UUID().uuidString
    var firstname : String
    var lastname : String
    var displayedName : String
    var email : String
    var image : Data
    var website : String
    var bio : String
}

class Post : ObservableObject{
    var caption : String!
    var imageDownloadURL : String?
    var image : UIImage!
    var id = Auth.auth().currentUser?.uid
    var postID : String?
    var NumberOfLikes : Int?
    var date = Date()

    
    var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
    
    init(image: UIImage, caption:String)  {
        self.image = image
        self.caption = caption
     
    }
   
    func convertImage(_ image : UIImage) -> Data{
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {return Data()}
        return imageData
    }
    func uploadPost(){
        // datebase Reference
        let newPostRef = Database.database().reference().child("posts").childByAutoId()
        let newPostKey = newPostRef.key
        
        
        // create  a storage reference
        let imageStorageRef = Storage.storage().reference().child("images")
        let newImageRef = imageStorageRef.child(newPostKey!)
        
        // save image to storage
       
        newImageRef.putData(convertImage(image),metadata: nil){(metadata,error) in
            guard let metadata = metadata else {
                return
            }
            _ = metadata.size
            newImageRef.downloadURL { (url, error) in
                guard url != nil else {
                    print(error!.localizedDescription)
                    return
                }
                self.imageDownloadURL = url?.absoluteString ?? "NO URL"
                self.postID = newPostKey ?? ""
                let newPostDictionary = [
                    "imageDownloadURL" : self.imageDownloadURL ?? "",
                    "caption" : self.caption ?? "",
                    "id" : self.id ?? "",
                    "postID" : self.postID ?? "",
                    "NumberOfLikes" : self.NumberOfLikes ?? 0,
                    "date":  self.dateFormatter.string(from: self.date)
                    
                ] 
                as [String : Any]
                newPostRef.setValue(newPostDictionary)
            }
        }
        
        }
}





class Add : ObservableObject{
    
    @Published var posts = [D_Post]()//.sorted(by: {$0.postID ?? "" > $1.postID ?? ""})
    
     var post = D_Post()
   
    var dateFormatter: DateFormatter {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
    
    init(){
    
        Database.database().reference().child("posts").observe(.childAdded){(snapshot) in
           
            var image: UIImage!
            let json = JSON(snapshot.value as Any)
            let imageDownloadURL = json["imageDownloadURL"].stringValue
            let imagStorageRef = Storage.storage().reference(forURL: imageDownloadURL)
            imagStorageRef.getData(maxSize: 2 * 1024 * 1024, completion: {(data, error) in
                if error != nil{
                    print("Error download image")
                }
                else{
                    if let imageData = data{
                     image = UIImage(data: imageData)
                        let caption = json["caption"].stringValue
                        let id = json["id"].stringValue
                        let postID = json["postID"].stringValue
                        let edited = json["edited"].bool
                        let NumberOfLikes = json["NumberOfLikes"].int
                        let dates = json["date"].stringValue
                        let date = self.dateFormatter.date(from: dates)
                   //     let image = image
                        let newPost = D_Post(id: id ,caption: caption,imageDownloadURL: imageDownloadURL,image:  image,postID: postID,edited: edited,NumberOfLikes: NumberOfLikes,date: date)
                        
                        
                        self.posts.append(newPost)
                }
                }
            })
          
            
           
         //   print(self.posts)
        }
        
 
    
       
    }
    
    func remove(postid : String?, img_url:String?){
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let storage = Storage.storage().reference(forURL:img_url ?? "")

         // Remove the post from the DB
        ref.child("posts").child(postid ?? "").removeValue { error,arg  in
           if error != nil {
            print("error \(error!.localizedDescription)")
           }
           else{
            print(postid ?? "" + "deleted sucefully")
           }
            
         }
         // Remove the image from storage
        let imageRef = storage.child("images").child(uid ?? "").child("\(postid ?? "").jpg")
         imageRef.delete { error in
           if  error != nil {
            print(error!.localizedDescription)
           } else {
            // File deleted successfully
           }
         }
        
       // showSheet.toggle()
    }
    
}

struct D_Post : Identifiable, Hashable{
    var id = UUID().uuidString
    var caption : String!
    var imageDownloadURL : String?
    var image : UIImage!
    var postID : String?
    var edited : Bool?
    var NumberOfLikes : Int?
    var date : Date?
}

/*
/// A class of types whose instances hold the value of an entity with stable identity.
protocol Identifiable {

    /// A type representing the stable identity of the entity associated with `self`.
    associatedtype ID: Hashable

    /// The stable identity of the entity associated with `self`.
    var id: ID { get }
}

extension Identifiable where Self: AnyObject {
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
}
*/

extension Post : Identifiable{
    
}

// // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //

