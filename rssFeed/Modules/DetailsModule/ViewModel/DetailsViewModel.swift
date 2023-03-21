import Foundation

protocol DetailsViewModelProtocol {
    var title: String { get }
    var link: String { get }
    var date: String { get }
    
    init(rssItem: Feed)
}

class DetailsViewModel: DetailsViewModelProtocol {
    var title: String {
        rssItem.title ?? ""
    }
    
    var link: String {
        rssItem.link ?? ""
    }
    
    var date: String {
        rssItem.date?.formattedDate ?? ""
    }
    
    private let rssItem: Feed
    
    required init(rssItem: Feed) {
        self.rssItem = rssItem
    }
}
