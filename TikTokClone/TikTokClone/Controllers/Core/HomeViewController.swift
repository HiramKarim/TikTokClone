//
//  ViewController.swift
//  TikTokClone
//
//  Created by Hiram Castro on 07/11/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private enum PagerSection {
        case FollowingFeed
        case ForYou
    }
    
    private let horizontalScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.bounces = false
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
        control.backgroundColor = nil
        control.selectedSegmentTintColor = .white
        return control
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
        setupHeaderButtons()
    }
    
    //MARK: - UI Config
    
    private func configView() {
        horizontalScrollView.delegate = self
        self.view.addSubview(horizontalScrollView)
        horizontalScrollView.contentSize = CGSize(width: self.view.width * 2, height: self.view.height)
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
    }
    
    private func setUpFeed() {
        makePagerForSection(.FollowingFeed)
        makePagerForSection(.ForYou)
    }
    
    private func setupHeaderButtons() {
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentControl(sender:)), for: .valueChanged)
        navigationItem.titleView = segmentedControl
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
    
    //MARK: - Action Buttons
    @objc
    private func didChangeSegmentControl(sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex),
                                                      y: 0),
                                              animated: true)
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

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x < (view.width / 2) {
            segmentedControl.selectedSegmentIndex = 0
        } else if scrollView.contentOffset.x > (view.width / 2) {
            segmentedControl.selectedSegmentIndex = 1
        }
    }
}
