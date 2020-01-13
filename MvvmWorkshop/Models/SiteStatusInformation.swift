//
//  SiteStatusInformation.swift
//  MvvmWorkshop
//
//  Created by Niklas Nilsson on 2020-01-13.
//  Copyright © 2020 Sveriges Radio AB. All rights reserved.
//

import Foundation

class SiteStatusInformation {
    let name: String
    let url: URL
    var statusCode: Int? = nil
    var lastChecked: Date? = nil

    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}
