//
//  CellA.swift
//  MvvmWorkshop
//
//  Created by Niklas Nilsson on 2020-01-13.
//  Copyright © 2020 Sveriges Radio AB. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol SimpleCellViewModelProtocol {
    var titleObservable: Observable<String?> { get }
    var subtitleObservable: Observable<String?> { get }
    var statusObservable: Observable<String?> { get }
    func start()
    func suspend()
}

class SimpleCell: UITableViewCell {

    let verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.spacing = 20
        return stackView
    }()

    let horizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private var disposeBag: DisposeBag? = DisposeBag()

    var viewModel: SimpleCellViewModelProtocol? {
        didSet {
            bind()
        }
    }

    private func bind() {
        let disposeBag = DisposeBag()

        viewModel?.titleObservable.subscribe(onNext: { [weak self] string in
            self?.titleLabel.text = string
        }).disposed(by: disposeBag)

        viewModel?.statusObservable.observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] string in
            self?.statusLabel.text = string
        }).disposed(by: disposeBag)

        viewModel?.subtitleObservable.observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] string in
            self?.subtitleLabel.text = string
        }).disposed(by: disposeBag)

        self.disposeBag = disposeBag
        self.viewModel?.start()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel?.suspend()
        
        self.disposeBag = nil

        self.titleLabel.text = nil
        self.statusLabel.text = nil
        self.subtitleLabel.text = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {

        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(subtitleLabel)

        horizontalStack.addArrangedSubview(verticalStack)
        horizontalStack.addArrangedSubview(statusLabel)

        contentView.addSubview(horizontalStack)
        contentView.addConstraints([
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])


    }

}
