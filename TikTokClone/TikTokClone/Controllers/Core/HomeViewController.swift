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
    }
    
    private func setUpFeed() {
        makePagerForSection(.FollowingFeed)
        makePagerForSection(.ForYou)
    }
    
    private func makePagerForSection(_ section:PagerSection) {
        let pagerFrame:CGRect
        
        switch section {
        case .FollowingFeed:
            pagerFrame = CGRect(x: 0,
                                y: 0, width: horizontalScrollView.width,
                                height: horizontalScrollView.height)
        case .ForYou:
            pagerFrame = CGRect(x: view.width,
                                y: 0,
                                width: horizontalScrollView.width,
                                height: horizontalScrollView.height)
        }
        
        let pagingController = UIPageViewController(transitionStyle: .scroll,
                                                    navigationOrientation: .vertical,
                                                    options: [:])
        
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        
        pagingController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        
        pagingController.dataSource = self
        
        horizontalScrollView.addSubview(pagingController.view)
        pagingController.view.frame = pagerFrame
        addChild(pagingController)
        pagingController.didMove(toParent: self)
    }
    
}

extension HomeViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = .gray
        return vc
    }
    
    
}
