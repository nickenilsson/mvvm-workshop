//
//  SiteInformationInputViewHelper.swift
//  MvvmWorkshop
//
//  Created by Niklas Nilsson on 2020-01-13.
//  Copyright © 2020 Sveriges Radio AB. All rights reserved.
//

import Foundation
import UIKit

struct SiteInformationInputViewHelper {

    static func siteInformationInputView(completion: @escaping (String?, String?) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: "Add site", message: "Please input a name and a URL", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Name of site"
        })
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Url address"
        })

        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { _ in

            //getting the input values from user
            let name = alertController.textFields?[0].text
            let url = alertController.textFields?[1].text
            completion(name, url)
        }

        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}
