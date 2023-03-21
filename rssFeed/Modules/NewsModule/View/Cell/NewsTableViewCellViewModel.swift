import Foundation

protocol NewsTableViewCellViewModelProtocol: AnyObject {
    var title: String { get }
    var date: String { get }
    var isReading: Bool  { get }
}

class NewsTableViewCellViewModel: NewsTableViewCellViewModelProtocol {
    
    private var feed: Feed
    
    var title: String {
        return feed.title ?? ""
    }
    
    var date: String {
        return feed.date?.formattedDate ?? "Date format error"
    }
    
    var isReading: Bool {
        return feed.isReading
    }
    
    init (feed: Feed) {
        self.feed = feed
    }
}
