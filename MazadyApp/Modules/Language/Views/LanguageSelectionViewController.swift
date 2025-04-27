//
//  LanguageSelectionViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//
import UIKit
import RxSwift
import RxCocoa

class LanguageSelectionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    private let viewModel = LanguageSelectionViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchTextField()
        bindViewModel()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        tableView.tableFooterView = UIView()
    }

    private func setupSearchTextField() {
        searchTextField.placeholder = "searchPlaceholder".localized()
        
        let imageView = UIImageView(image: .searchNormalIcon)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        imageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        containerView.addSubview(imageView)

        searchTextField.leftView = containerView
        searchTextField.leftViewMode = .always

        searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { [weak self] text in
                self?.viewModel.filterLanguages(searchText: text)
            }
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.filteredLanguagesRelay
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    @IBAction func closeBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableView
extension LanguageSelectionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.languagesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as? LanguageCell else {
            return UITableViewCell()
        }
        let cellVM = viewModel.cellViewModel(at: indexPath.row)
        cell.configure(with: cellVM)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectLanguage(at: indexPath.row)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
