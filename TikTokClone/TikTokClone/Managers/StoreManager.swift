//
//  StoreManager.swift
//  TikTokClone
//
//  Created by Hiram Castro on 07/11/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    public static let shared = StorageManager()
    
    private let database = Storage.storage().reference()
    
    private init() { }
    
    // Public
    
    public func fetchViewURL(with Identifier: String, completion: @escaping (URL) -> Void) {
        
    }
    
    public func uploadViewURL(from url: URL) {
        
    }
    
}
