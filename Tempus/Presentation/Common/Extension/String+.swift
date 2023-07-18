//
//  String+.swift
//  Tempus
//
//  Created by 이정민 on 2023/07/18.
//

import Foundation
 
extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
