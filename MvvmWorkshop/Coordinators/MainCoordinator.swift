//
//  MainCoordinator.swift
//  MvvmWorkshop
//
//  Created by Niklas Nilsson on 2020-01-14.
//  Copyright © 2020 Sveriges Radio AB. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator {
    let window: UIWindow
    func start() {
        let vm = ListViewControllerViewModel(coordinator: self)
        let vc = ListViewController(viewModel: vm)

        window.makeKeyAndVisible()
        let navigationViewController = UINavigationController(rootViewController: vc)
        window.rootViewController = navigationViewController
    }

    func presentSiteInputView(completion: @escaping (String?, String?) -> Void) {

        let vc = SiteInformationInputViewHelper.siteInformationInputView(completion: completion)

        window.rootViewController?.present(vc, animated: true, completion: {})
    }

    init(window: UIWindow) {
        self.window = window
    }
}
