import UIKit

class SourceTableViewCell: UITableViewCell {
    static let reuseId = "SoruceTableViewCell"
    
    weak var viewModel: SourceTableViewCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            urlLabel.text = viewModel.url
            self.accessoryType = viewModel.isCurrent ? .checkmark : .none
        }
    }
    
// MARK: - Creating custom cell objects
   private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .black

        return label
    }()

    let urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .gray

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        self.tintColor = UIColor(named: "AppColor")

        overlayFirstLayer()
        overlaySecondLayer()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
/// Overlay first UI layer
    func overlayFirstLayer() {
        addSubview(cardView)

        cardView.setPosition(top: topAnchor,
                             left: leftAnchor,
                             bottom: nil,
                             right: rightAnchor,
                             paddingTop: 12,
                             paddingLeft: 16,
                             paddingBottom: 12,
                             paddingRight: 12)
        
        let bottomConstraint = cardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(999)
        bottomConstraint.isActive = true
    }
    
/// Overlay second UI layer
    func overlaySecondLayer() {

        cardView.addSubview(titleLabel)
        cardView.addSubview(urlLabel)
        
        titleLabel.setPosition(top: cardView.topAnchor,
                                       left: cardView.leftAnchor,
                                       bottom: nil,
                                       right: cardView.rightAnchor,
                                       paddingTop: 16,
                                       paddingLeft: 12,
                                       paddingBottom: 0,
                                       paddingRight: 10)

        urlLabel.setPosition(top: titleLabel.bottomAnchor,
                              left: titleLabel.leftAnchor,
                              bottom: cardView.bottomAnchor,
                              right: cardView.rightAnchor,
                              paddingTop: 4,
                              paddingLeft: 0,
                              paddingBottom: 12,
                              paddingRight: 10)
    }

}
