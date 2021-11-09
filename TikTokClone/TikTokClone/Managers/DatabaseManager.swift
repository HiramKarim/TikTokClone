//
//  DatabaseManager.swift
//  TikTokClone
//
//  Created by Hiram Castro on 07/11/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init() { }
    
    // Public
    
    public func getAllUsers(completion: @escaping ([String]) -> Void) {
        
    }
    
}
