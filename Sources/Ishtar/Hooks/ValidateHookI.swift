import Foundation

struct ValidateHookI: Hook {
    typealias T = @convention(c) (
        AnyObject,
        Selector
    ) -> Bool
    
    let `class`: AnyClass?
    let selector: Selector
    let replacement: T = { _, _ in
        true
    }
}

