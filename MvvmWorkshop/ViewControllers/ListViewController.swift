//
//  ViewController.swift
//  MvvmWorkshop
//
//  Created by Niklas Nilsson on 2020-01-13.
//  Copyright © 2020 Sveriges Radio AB. All rights reserved.
//

import UIKit
import RxSwift

protocol ListViewControllerViewModelProtocol {
    var reloadDataObservable: Observable<Void> { get }
    var cellViewModels: [SimpleCellViewModelProtocol] { get }
    func addButtonPressed()
}

class ListViewController: UIViewController, UITableViewDataSource {
    let viewModel: ListViewControllerViewModelProtocol
    let disposeBag: DisposeBag

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.register(SimpleCell.self, forCellReuseIdentifier: "cell")
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "MVVM workshop"
        setupViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        setupViewModelSubscriptions()
    }

    private func setupViewModelSubscriptions() {
    viewModel.reloadDataObservable.observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    override func loadView() {
        view = UIView()
        super.loadView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: ListViewControllerViewModelProtocol) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }

    private func setupViews() {
        view.addSubview(tableView)
        view.addConstraints([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func addButtonPressed() {
        viewModel.addButtonPressed()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let simpleCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleCell

        simpleCell.viewModel = viewModel.cellViewModels[indexPath.item]
        
        return simpleCell
    }

}

