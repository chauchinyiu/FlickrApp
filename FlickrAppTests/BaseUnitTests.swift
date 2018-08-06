//
//  BaseUnitTests.swift
//  FlickrAppTests
//
//  Created by Chau Chin Yiu on 03.08.18.
//  Copyright © 2018 Chau Chin Yiu. All rights reserved.
//

import XCTest
import LittleFramework

class BaseUnitTests: XCTestCase {
    
 
    var expectationBinders = [Any]()
    var expectationSignalReceivers = [Any]()
    
    override func setUp() {
        super.setUp()
      
    }
    
    override func tearDown() {
        super.tearDown()
        expectationBinders.removeAll()
        expectationSignalReceivers.removeAll()
    }
    
    // MARK: - Bindings Expectations
    
    final func expect<T>(_ bindable: Bindable<T>, description: String? = nil, toPassValueTest fulfillmentTest: @escaping ((T) -> Bool), failOtherwise: Bool = false) {
        let expectation = self.expectation(description: description ?? "Bindable \(bindable) fulfills custom expectation")
        var bound = false
        var fulfilled = false
        let binder = Binder<T> { (value: T) in
            if bound {
                guard !fulfilled else { return }
                if fulfillmentTest(value) {
                    expectation.fulfill()
                    fulfilled = true
                } else if failOtherwise {
                    XCTFail("Bindable did change to unexpected value: \(value) which causes this test to fail")
                } else {
                    print("Bindable did change to unexpected value: \(value) but this is not a failure")
                }
            } else {
                bound = true
            }
        }
        expectationBinders.append(binder)
        binder <~ bindable
    }
    
    final func expect<T: Equatable>(_ bindable: Bindable<T?>, toChangeValueTo expectedValue: T?, failOtherwise: Bool = false) {
        expect(bindable, description: "Bindable \(bindable) changes value to \(String(describing: expectedValue))", toPassValueTest: { $0 == expectedValue }, failOtherwise: failOtherwise)
    }
    
    final func expect<T: Equatable>(_ bindable: Bindable<T>, toChangeValueTo expectedValue: T, failOtherwise: Bool = false) {
        expect(bindable, description: "Bindable \(bindable) changes value to \(expectedValue)", toPassValueTest: { $0 == expectedValue }, failOtherwise: failOtherwise)
    }
    
    final func expectNil<T>(_ bindable: Bindable<T?>, failOtherwise: Bool = false) {
        expect(bindable, description: "Bindable \(bindable) changes value to nil", toPassValueTest: { $0 == nil }, failOtherwise: failOtherwise)
    }
    
    final func expectNotNil<T>(_ bindable: Bindable<T?>, failOtherwise: Bool = false) {
        expect(bindable, description: "Bindable \(bindable) changes to non-nil value", toPassValueTest: { $0 != nil }, failOtherwise: failOtherwise)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    

}
