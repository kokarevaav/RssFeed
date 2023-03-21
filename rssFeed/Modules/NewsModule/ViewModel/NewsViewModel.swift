import Foundation

protocol NewsViewModelProtocol: AnyObject {
    var news: [Feed] { get set }
    var currentSource: Source { get set }
    func fetchNewsFromInternet(completion: @escaping() -> Void)
    func fetchNewsFromCoreData()
    func saveNewsToCoreData()
    func getNumberOfRows() -> Int
    func cellViewModel(forIndexPath: IndexPath) -> NewsTableViewCellViewModelProtocol
    func viewModelForSelectedRow(at indexPath: IndexPath) -> DetailsViewModelProtocol
}

class NewsViewModel: NewsViewModelProtocol {
    private let rssParser: RSSParser = RSSParser()
    
    var news: [Feed] = []
    var currentSource: Source = Source(title: "Банки.РУ", url: "https://www.banki.ru/xml/news.rss")
    
    func fetchNewsFromInternet(completion: @escaping () -> Void) {
        news = []
        rssParser.updateNews(currentSource: currentSource.url) { [unowned self] news in
            self.news = news
            self.saveNewsToCoreData()
            completion()
        }
    }
    
    func fetchNewsFromCoreData() {
        guard let news = CoreDataManager.shared.loadNews() else { return }
        self.news = news
    }
    
    func saveNewsToCoreData() {
        CoreDataManager.shared.saveNews(news: news)
    }
    
    func getNumberOfRows() -> Int {
        return news.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> NewsTableViewCellViewModelProtocol {
        NewsTableViewCellViewModel(feed: news[indexPath.row])
    }
    
    func viewModelForSelectedRow(at indexPath: IndexPath) -> DetailsViewModelProtocol {
        DetailsViewModel(rssItem: news[indexPath.row])
    }
}
