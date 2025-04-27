//
//  LanguageSelectionViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import UIKit

class LanguageSelectionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var languages = ["English", "العربية"]
    var filteredLanguages: [String] = []
    
    var selectedLanguage: String?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredLanguages = languages
        setupTableView()
        setupSearchTextField()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func setupSearchTextField() {
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }

    @objc private func searchTextChanged() {
        guard let text = searchTextField.text, !text.isEmpty else {
            filteredLanguages = languages
            tableView.reloadData()
            return
        }
        filteredLanguages = languages.filter { $0.localizedCaseInsensitiveContains(text) }
        tableView.reloadData()
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableView
extension LanguageSelectionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLanguages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let language = filteredLanguages[indexPath.row]
        cell.textLabel?.text = language
        cell.accessoryType = (language == selectedLanguage) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = filteredLanguages[indexPath.row]
        // Here you can handle saving the selected language
        print("Selected Language: \(selectedLanguage ?? "")")
        dismiss(animated: true, completion: nil)
    }
}
