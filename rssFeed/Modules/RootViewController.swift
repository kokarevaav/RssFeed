import UIKit

class RootViewController: UITabBarController {

    private var currentTabBarIndex: Int = 0
    private let newsVC = NewsViewController()
    private let sourcesVC = SourcesViewController()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        sourcesVC.delegate = newsVC
        configureViewController()
    }
    
    override func viewDidLayoutSubviews() {
        setupTabBar()
    }
    
//MARK: Arrangement of UI elements
    private func configureViewController() {
        
        guard let rssImage = UIImage(named: "rss"),
              let sourceImage = UIImage(named: "sources") else { return }
        
        let news = constructNavController(selectedImage: rssImage, rootViewController: newsVC, navTitle: "Main", tabBarTag: 0)
        let source = constructNavController(selectedImage: sourceImage, rootViewController: sourcesVC, navTitle: "Soureces", tabBarTag: 1)
        
        viewControllers = [news, source]
    }
    
    private func constructNavController(selectedImage: UIImage, rootViewController: UIViewController, navTitle: String, tabBarTag: Int) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = selectedImage
        navController.tabBarItem.title = navTitle
        navController.tabBarItem.tag = tabBarTag
        
        navController.viewControllers.first?.navigationItem.title = navTitle
        
        return navController
    }
    
    private func setupTabBar() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        guard let tabItems = tabBar.items else { return }

        let numberOfItems = CGFloat(tabItems.count)
        var safeAreaInset: CGFloat = 0.0

        if window?.safeAreaInsets.bottom != nil {
            safeAreaInset = 6
        }
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems + 10, height: tabBar.frame.height + 10 + safeAreaInset)
        
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(named: "AppColor")!, size: tabBarItemSize)
        
        tabBar.tintColor = .white
    }

}

extension RootViewController: UITabBarControllerDelegate {
    
}
