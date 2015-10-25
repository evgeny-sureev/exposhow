//
//  PavilionsMap.swift
//  exposhow
//
//  Created by Ulitka on 12.09.15.
//  Copyright (c) 2015 Ampullarius. All rights reserved.
//

import Foundation
import UIKit

struct Pavilion {
    let name: String
    let pavilion: String
    let position: CGRect
}

class PavilionsMap {
    
    var pavilions:[Pavilion]
    
    init() {
        let pavilionsURL = NSBundle.mainBundle().resourceURL?.URLByAppendingPathComponent("pavilions.csv")

        pavilions = []
        if let csv_file = try? String(contentsOfURL: pavilionsURL!, encoding: NSUTF8StringEncoding) {
            csv_file.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet()).enumerateLines { line, stop in
                let values = line.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ";"))
                if values.count != 6 {
                    return
                }
                let name = values[0]
                let pavilion = values[1]
                let x = Int(values[2])
                let y = Int(values[3])
                let width = Int(values[4])
                let height = Int(values[5])
                if let x = x, let y = y, let width = width, let height = height {
                    self.pavilions.append(Pavilion(name: name, pavilion: pavilion, position: CGRect(x: x, y: y, width: width, height: height)))
                }
            }
        } else {
            print("Error opening file")
        }
        pavilions.sortInPlace { $0.name.lowercaseString < $1.name.lowercaseString }
    }
    
    var count:Int {
        return pavilions.count
    }
    
    subscript(index:Int) -> Pavilion {
        return pavilions[index]
    }

    func indexOfPavilionAtPoint(point:CGPoint) -> Int? {
        for i in 0..<pavilions.count {
            if pavilions[i].position.contains(point) {
                return i
            }
        }
        return nil
    }
}