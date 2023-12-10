//
//  AuthViewModel.swift
//  YPick
//
//  Created by Chris Moreira on 12/2/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

//@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    var showAlert: ((String, String) -> Void)?
 
    init(){
        Task{
            await fetchUser
        }
    }
    
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Bool) -> Void) async {
           do {
               let result = try await Auth.auth().signIn(withEmail: email, password: password)
               self.userSession = result.user
               await fetchUser()
               completion(true)
           } catch {
               print("Debug: Failed to log in with error \(error.localizedDescription)")
               completion(false)
               showAlert?("Login Failed", "Invalid email or password.")
           }
       }

    
    func createUser(withEmail email: String, password: String, fullname: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user) 
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        }catch{
            print("Debug: Failed to crate user with error \(error.localizedDescription)")
        }
    }
    func signOut(){
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    func deleteAccount(){
        
    }
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("Debug: Current user is \(self.currentUser)")
    }
}
