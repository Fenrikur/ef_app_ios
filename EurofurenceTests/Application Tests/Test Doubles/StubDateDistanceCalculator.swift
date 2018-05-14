//
//  StubDateDistanceCalculator.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubDateDistanceCalculator: DateDistanceCalculator {
    
    func calculateDays(between first: Date, and second: Date) -> Int {
        let input = Input(first: first, second: second)
        return stubbedValues[input] ?? .random
    }
    
    private struct Input: Hashable {
        var first: Date
        var second: Date
        
        var hashValue: Int {
            return first.hashValue ^ second.hashValue
        }
        
        static func ==(lhs: StubDateDistanceCalculator.Input, rhs: StubDateDistanceCalculator.Input) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
    
    private var stubbedValues = [Input : Int]()
    func stubDistance(between first: Date, and second: Date, with days: Int) {
        stubbedValues[Input(first: first, second: second)] = days
    }
    
}