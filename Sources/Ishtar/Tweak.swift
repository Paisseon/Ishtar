import Foundation

struct Tweak {
    static let config: Config = .jinx

    static func ctor() {
        guard ProcessInfo.processInfo.arguments[0].hasPrefix("/var/containers/Bundle/Application"),
              Bundle.main.bundleIdentifier?.hasPrefix("com.apple.") != true
        else {
            return
        }
        
        guard let (auth, user): (AnyClass, AnyClass) = RuntimeMagic.findClasses() else {
            return
        }

        guard let isVip: Selector = RuntimeMagic.findSelector(in: user),
              let validateVipFeatureI: Selector = RuntimeMagic.findSelector(in: auth),
              let validateVipFeatureII: Selector = RuntimeMagic.findSelector(in: auth, excluding: validateVipFeatureI)
        else {
            return
        }

        UsernameHook(class: user).hook()
        ValidateHookI(class: auth, selector: validateVipFeatureI).hook()
        ValidateHookII(class: auth, selector: validateVipFeatureII).hook()
        VipHook(class: user, selector: isVip).hook()
    }
}
