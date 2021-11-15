//
//  PostModel.swift
//  TikTokClone
//
//  Created by Hiram Castro on 14/11/21.
//

import Foundation

struct PostModel {
    let identifier:String
    
    static func mockModels() -> [PostModel] {
        return Array(0...100).map { _ in  PostModel(identifier: UUID().uuidString) }
    }
}
