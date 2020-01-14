//
//  StatusCellViewModel.swift
//  MvvmWorkshop
//
//  Created by Niklas Nilsson on 2020-01-14.
//  Copyright © 2020 Sveriges Radio AB. All rights reserved.
//

import Foundation
import RxSwift

class SiteCellViewModel: SimpleCellViewModelProtocol {
    var titleObservable: Observable<String?>
    var subtitleObservable: Observable<String?>
    var statusObservable: Observable<String?> {
        get {
            statusBehaviorSubject.asObservable()
        }
    }

    private var statusBehaviorSubject: BehaviorSubject<String?>
    private var disposeBag: DisposeBag?
    private let url: URL

    init(site: Site) {
        url = site.url
        titleObservable = Observable.just(site.name)
        subtitleObservable = Observable.just(site.url.absoluteString)
        statusBehaviorSubject = BehaviorSubject(value: "0")
    }

    func start() {
        let disposeBag = DisposeBag()
        Observable<Int>.timer(.seconds(10), scheduler: MainScheduler.asyncInstance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            StatusCodeChecker.check(url: self.url) { (result) in
                switch result {
                case .failure:
                    self.statusBehaviorSubject.onNext("E")
                case .success(let int):
                    self.statusBehaviorSubject.onNext(String(int))
                }
            }

        }).disposed(by: disposeBag)

        self.disposeBag = disposeBag
    }

    func suspend() {
        disposeBag = nil
    }
}
