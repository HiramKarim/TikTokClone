//
//  ViewController.swift
//  TikTokClone
//
//  Created by Hiram Castro on 07/11/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    private enum PagerSection {
        case FollowingFeed
        case ForYou
    }
    
    private let horizontalScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .red
        scroll.bounces = false
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private var followingPosts = PostModel.mockModels()
    private var forYouPosts = PostModel.mockModels()
    
    //MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .systemBackground
        
        configView()
        setUpFeed()
    }
    
    //MARK: - UI Config
    
    private func configView() {
        self.view.addSubview(horizontalScrollView)
        horizontalScrollView.contentSize = CGSize(width: self.view.width * 2, height: self.view.height)
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
    }
    
    private func setUpFeed() {
        makePagerForSection(.FollowingFeed)
        makePagerForSection(.ForYou)
    }
    
    //MARK: - Factory Methods
    
    private func makePagerForSection(_ section:PagerSection) {
        let pagingController = UIPageViewController(transitionStyle: .scroll,
                                                    navigationOrientation: .vertical,
                                                    options: [:])
        
        let pagerFrame:CGRect
        
        switch section {
        case .FollowingFeed:
            guard let model = followingPosts.first else {
                return
            }
            pagingController.setViewControllers([PostViewController(model: model)], direction: .forward, animated: false, completion: nil)
            pagerFrame = CGRect(x: 0,
                                y: 0, width: horizontalScrollView.width,
                                height: horizontalScrollView.height)
        case .ForYou:
            guard let model = forYouPosts.first else {
                return
            }
            pagingController.setViewControllers([PostViewController(model: model)], direction: .forward, animated: false, completion: nil)
            pagerFrame = CGRect(x: view.width,
                                y: 0,
                                width: horizontalScrollView.width,
                                height: horizontalScrollView.height)
        }
        
        pagingController.dataSource = self
        
        horizontalScrollView.addSubview(pagingController.view)
        pagingController.view.frame = pagerFrame
        addChild(pagingController)
        pagingController.didMove(toParent: self)
    }
    
    private func obtainLastIndex(_ viewController: UIViewController) -> Int? {
        guard let fromPost = (viewController as? PostViewController)?.postModel else {
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        return index
    }
    
}

extension HomeViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = obtainLastIndex(viewController)
        
        guard let index = index else {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = obtainLastIndex(viewController)
        
        guard let index = index else {
            return nil
        }
        
        guard index < (currentPosts.count - 1) else {
            return nil
        }
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    var currentPosts: [PostModel] {
        if horizontalScrollView.contentOffset.x == 0 {
            // following
            return followingPosts
        } else {
            // for you
            return forYouPosts
        }
    }
    
}
