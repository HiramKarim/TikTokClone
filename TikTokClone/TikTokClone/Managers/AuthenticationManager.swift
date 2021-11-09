//
//  AuthenticationManager.swift
//  TikTokClone
//
//  Created by Hiram Castro on 07/11/21.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    static let shared = AuthManager()
    
    private init() { }
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
    
}
