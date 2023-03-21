import Foundation

protocol SourcesViewModelProtocol {
    var sources: [Source] { get set }
    var currentSource: Source? { get set }
    
    func getNumberOfRows() -> Int
    func cellViewModel(forIndexPath: IndexPath) -> SourceTableViewCellViewModelProtocol?
    func saveSourcesInUserDefaults()
    func loadSourcesFromUserDefaults()
    func createNewSource(title: String, url: String, isCurrent: Bool)
    func resetCurrentSource()
}

class SourcesViewModel: SourcesViewModelProtocol {
    var sources: [Source] = []
    
    var currentSource: Source?
    
    func getNumberOfRows() -> Int {
        return sources.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> SourceTableViewCellViewModelProtocol? {
        SourceTableViewCellViewModel(source: sources[indexPath.row])
    }
    
    func saveSourcesInUserDefaults() {
        var sourcesTitle: [String] = []
        var sourcesURL: [String] = []
        
        for i in 0..<sources.count {
            sourcesTitle.append(sources[i].title)
            sourcesURL.append(sources[i].url)
        }
        
        UserDataManager.saveSources(sourcesTitle: sourcesTitle, sourcesURL: sourcesURL)
    }
    
    func loadSourcesFromUserDefaults() {
        sources = []
        let title = UserDataManager.getSourcesTitle()
        let url = UserDataManager.getSourcesURL()
        
        if !title.isEmpty {
            for i in 0..<title.count {
                if i == 0 {
                    sources.append(Source(title: title[i], url: url[i], isCurrent: true))
                } else {
                    sources.append(Source(title: title[i], url: url[i], isCurrent: false))
                }
            }
        }
    }
    
    func createNewSource(title: String, url: String, isCurrent: Bool) {
        let newSource = Source(title: title, url: url, isCurrent: true)
        currentSource = newSource
        resetCurrentSource()
        self.sources.append(newSource)
    }
    
    func resetCurrentSource() {
        if !sources.isEmpty {
            sources.indices.forEach { sources[$0].isCurrent = false }
        }
    }
}
