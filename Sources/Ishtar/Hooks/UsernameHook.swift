import Foundation

struct UsernameHook: Hook {
    typealias T = @convention(c) (
        AnyObject,
        Selector,
        String
    ) -> Void
    
    let `class`: AnyClass?
    let selector: Selector = sel_registerName("setUsername:")
    let replacement: T = { `self`, cmd, _ in
        let orig: T = PowPow.unwrap(UsernameHook.self)!
        orig(`self`, cmd, "Cracked by CyPwn")
    }
}
