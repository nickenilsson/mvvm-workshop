//
//  ListViewControllerViewModel.swift
//  MvvmWorkshop
//
//  Created by Niklas Nilsson on 2020-01-14.
//  Copyright © 2020 Sveriges Radio AB. All rights reserved.
//

import Foundation
import RxSwift

class ListViewControllerViewModel: ListViewControllerViewModelProtocol {

    var coordinator: MainCoordinator
    var reloadDataObservable: Observable<Void> {
        get {
            reloadDataPublishSubject.asObservable()
        }
    }
    private var reloadDataPublishSubject: PublishSubject<Void> = PublishSubject()
    var cellViewModels: [SimpleCellViewModelProtocol] = []

    func addButtonPressed() {
        coordinator.presentSiteInputView(completion:{ [weak self] name, url in
            guard let name = name, let urlString = url, let url = URL(string: urlString) else {
                return
            }
            let site = Site(name: name, url: url)
            let cellViewModel = SiteCellViewModel(site: site)
            self?.cellViewModels.append(cellViewModel)
            self?.reloadDataPublishSubject.onNext(())
        })
    }


    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }

}
