//
//  StorageController.swift
//  Pleyeces
//
//  Created by FOI on 20/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let disabledCategoryIds = DefaultsKey<[Int]>("disabledCategoryIds")
    static let radius = DefaultsKey<Int>("radius")
    static let launchedBefore=DefaultsKey<Bool>("launchedBefore")
}
