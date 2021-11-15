//
//  PostViewController.swift
//  TikTokClone
//
//  Created by Hiram Castro on 07/11/21.
//

import UIKit

class PostViewController: UIViewController {
    
    var postModel:PostModel
    
    init(model: PostModel) {
        self.postModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let colors:[UIColor] = [
            .red, .green, .black, .orange, .blue, .white, .systemPink
        ]
        
        self.view.backgroundColor = colors.randomElement()
    }

}
