//
//  Array+Only.swift
//  Memorize
//
//  Created by Nathan Henrie on 20210326.
//  Copyright © 2021 com.n8henrie. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
