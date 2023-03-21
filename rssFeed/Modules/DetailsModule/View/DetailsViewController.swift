import UIKit
import CoreData
import WebKit

class DetailsViewController: UIViewController, WKNavigationDelegate{
    
    // MARK: - Свойства
    var viewModel: DetailsViewModelProtocol!
    var webView: WKWebView!
    
    // MARK: - Функции
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
        guard let url = URL(string: viewModel.link) else {return}
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func configureViewComponents() {
        self.navigationItem.title = "News"
        view.backgroundColor = .white
    }
}
