//
//  NSIndexPath.swift
//  Tableau
//
//  Created by Jason Barker on 8/25/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

extension NSIndexPath {
    
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self != NSIndexPath.self {
            return
        }
        
        /*  SWIZZLE METHODS: 'row' for 'rowIndex'
         Apple's original definition of 'row' results in an exception when the following conditions are met:
         + the length of the NSIndexPath object is not equal to two
         + the accessor 'row' is invoked
         The exception thrown is:
         *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Invalid index path for use with UITableView.  Index paths passed to table view must contain exactly two indices specifying the section and row.  Please use the category on NSIndexPath in UITableView.h if possible.'
         
         I have added a third index 'column' to specify a column index, which results in the above exception being thrown. As a last resort, I have resorted to swizzling the method with a more 'flexible' approach.
         If you find a suitable alternate method, please implement it in place of this.
         */
        dispatch_once(&Static.token) {
            let originalSelector = Selector("row")
            let swizzledSelector = Selector("rowIndex")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            }
            else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    var column: Int {
        if length >= 3 {
            return indexAtPosition(2)
        }
        return 0
    }
    
    var rowIndex: Int {
        return indexAtPosition(1)
    }
    
    func indexPathWithColumn(column: Int) -> NSIndexPath {
        let indices = [indexAtPosition(0), indexAtPosition(1), column]
        return NSIndexPath(indexes: indices, length: indices.count)
    }
}
