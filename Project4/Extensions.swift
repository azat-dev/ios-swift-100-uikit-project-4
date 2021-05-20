//
//  Extensions.swift
//  Project4
//
//  Created by Azat Kaiumov on 20.05.2021.
//

import Foundation

extension String {
    func isMatch(pattern: String) -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        
        let match = regex.firstMatch(in: self, options: [], range: range)
            
        return match != nil
    }
}
