import UIKit

protocol SourcesDelegateProtocol: AnyObject {
    func updateSource(source: Source)
}

class SourcesViewController: UIViewController{
    
    private var viewModel: SourcesViewModelProtocol!
    weak var delegate: SourcesDelegateProtocol?
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        setupTableView()
        setupAddSourceBarButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SourcesViewModel()
        viewModel.loadSourcesFromUserDefaults()
    }
    
    private lazy var addSourceAlert: UIAlertController = {
        let alert = UIAlertController(title: "Add RSS-source", message: "Enter the name of the source and its address", preferredStyle:UIAlertController.Style.alert)
        
        alert.addTextField {
            $0.placeholder = "Name"
            $0.delegate = self
            $0.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        }
        
        alert.addTextField {
            $0.placeholder = "Address"
            $0.delegate = self
            $0.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
                                    (action : UIAlertAction) -> Void in })
        
        alert.addAction(cancel)
        
        let save = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { [unowned self] saveAction -> Void in
            guard let titleTextField = alert.textFields?[0],
                  let urlTextField = alert.textFields?[1] else { return }
            
            guard let title = titleTextField.text, let url = urlTextField.text else { return }
                        
            self.viewModel.createNewSource(title: title, url: url, isCurrent: true)
            guard let currentSource = self.viewModel.currentSource else { return }
            
            self.tableView.reloadData()
            self.delegate?.updateSource(source: currentSource)
            self.viewModel.saveSourcesInUserDefaults()
           
            titleTextField.text = ""
            urlTextField.text = ""
            saveAction.isEnabled = false
        })
        
        save.isEnabled = false
        alert.addAction(save)
    
        return alert
    }()
    
    private let emptySourceLabel: UILabel = {
        let label = UILabel()
        label.text = "You don't seem to have any sources yet\n Add them!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptySourceImage: UIImageView = {
        let image = UIImage(named: "notFound")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @objc func addSourceClicked(btn: UIBarButtonItem){
        self.present(addSourceAlert, animated: true, completion: nil)
    }
    
    private func setupAddSourceBarButton() {
        let addSourceBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSourceClicked(btn:)))
        self.navigationItem.rightBarButtonItem  = addSourceBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "AppColor")
    }
    
/// Setting UITableView
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.addSubview(emptySourceLabel)
        tableView.addSubview(emptySourceImage)
        setupConstraints()
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(SourceTableViewCell.self, forCellReuseIdentifier: SourceTableViewCell.reuseId)
        
        setupConstraints()
    }
    
/// Setting Constraint for UITableView
    private func setupConstraints() {
        tableView.fillToSuperView(view: view)
        
        emptySourceLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptySourceLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 50).isActive = true

        emptySourceImage.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptySourceImage.topAnchor.constraint(equalTo: emptySourceLabel.bottomAnchor, constant: 25).isActive = true
    }
    

}
// MARK: - UITableViewDataSource
extension SourcesViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            emptySourceLabel.isHidden = viewModel.getNumberOfRows() != 0
            emptySourceImage.isHidden = viewModel.getNumberOfRows() != 0
    
           return viewModel.getNumberOfRows()
        }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
            self.viewModel.sources.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.viewModel.saveSourcesInUserDefaults()
          }
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SourceTableViewCell.reuseId, for: indexPath) as? SourceTableViewCell else { return UITableViewCell() }
            cell.viewModel = viewModel.cellViewModel(forIndexPath: indexPath)
    
            return cell
        }
}

// MARK: - UITableViewDelegate
extension SourcesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.resetCurrentSource()
        
        viewModel.currentSource = viewModel.sources[indexPath.row]
        
        viewModel.sources[indexPath.row].isCurrent = true
        
        tableView.reloadData()
        
        guard let newSource = viewModel.currentSource else { return }
        self.delegate?.updateSource(source: newSource)
    }
}

//MARK:- UITextFieldDelegate
extension SourcesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
