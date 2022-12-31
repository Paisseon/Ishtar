import Foundation

struct ValidateHookII: Hook {
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
