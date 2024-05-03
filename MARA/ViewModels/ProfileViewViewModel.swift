//
//  ProfileViewViewModel.swift
//  MARA
//
//  Created by USER on 31/01/2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class ProfileViewViewModel: ObservableObject {
    init() {}
    
    @Published var user: User? = nil
    
    /// Convert user's infomation from Firebase database to User class
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0
                )
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}