//
//  SelectCityViewController.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//
import UIKit

class SelectCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var viewModel: CreateTripViewModel?
    var onCitySelected: ((Location) -> Void)?

    private let searchTextField = UITextField()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        title = "Select City"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
    }
    
    init(viewModel: CreateTripViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Please select a city"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.gray

        searchTextField.placeholder = "Where to?"
        searchTextField.borderStyle = .roundedRect
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        searchTextField.becomeFirstResponder()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityCell.self, forCellReuseIdentifier: "CityCell")
        tableView.rowHeight = 60

        [titleLabel, searchTextField, tableView].forEach { view.addSubview($0) }

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 44),

            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func textDidChange(_ textField: UITextField) {
        if let text = textField.text {
            viewModel?.beginSearch(for: text)
            tableView.reloadData()
        }
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.filteredLocationData.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        let location = viewModel?.filteredLocationData[indexPath.row]
        cell.configure(with: location)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = viewModel?.filteredLocationData[indexPath.row]
        guard let location else { return }
        viewModel?.selectedLocation = location
        onCitySelected?(location)
        dismiss(animated: true)
    }
}
