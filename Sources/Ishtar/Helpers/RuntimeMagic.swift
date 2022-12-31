import Foundation

struct RuntimeMagic {
    static func findClasses() -> (AnyClass, AnyClass)? {
        var imageCount: UInt32 = 0
        var classCount: UInt32 = 0
        
        let imagesPtr: UnsafeMutablePointer<UnsafePointer<Int8>> = objc_copyImageNames(&imageCount)
        let imagesBuf: UnsafeMutableBufferPointer = .init(start: imagesPtr, count: Int(imageCount))
        
        let images: [String] = imagesBuf
            .map { String(cString: UnsafePointer<Int8>($0)) }
            .filter { !$0.hasPrefix("/System") && $0.hasSuffix(".dylib") }
        
        defer {
            free(imagesPtr)
        }
        
        for image in images {
            guard let classesPtr: UnsafeMutablePointer<UnsafePointer<Int8>> = objc_copyClassNamesForImage(image, &classCount) else {
                continue
            }
            
            let classesBuf: UnsafeMutableBufferPointer = .init(start: classesPtr, count: Int(classCount))
            let classes: [String] = classesBuf.map { String(cString: UnsafePointer<Int8>($0)) }
            
            defer {
                free(classesPtr)
            }
            
            let authName: String = classes.first(where: { `class` in
                let tmp: AnyClass? = objc_getMetaClass(`class`) as? AnyClass
                return class_getClassMethod(tmp, sel_registerName("logo")) != nil
            }) ?? ""
            
            let userName: String = classes.first(where: { `class` in
                let tmp: AnyClass? = objc_getClass(`class`) as? AnyClass
                return class_getProperty(tmp, "isVip") != nil
            }) ?? ""
            
            if !authName.isEmpty,
               !userName.isEmpty,
               let auth: AnyClass = objc_getMetaClass(authName) as? AnyClass,
               let user: AnyClass = objc_getClass(userName) as? AnyClass
            {
                return (auth, user)
            }
        }
        
        return nil
    }
    
    static func findSelector(
        in class: AnyClass,
        excluding excluded: Selector? = nil
    ) -> Selector? {
        var methodCount: UInt32 = 0
        
        guard let methodsPtr: UnsafeMutablePointer<Method> = class_copyMethodList(`class`, &methodCount) else {
            return nil
        }
        
        let methodsBuf: UnsafeMutableBufferPointer = .init(start: methodsPtr, count: Int(methodCount))
        let methods: [Method] = methodsBuf.map { $0 }
        
        let ret: Method? = methods.first(where: { method in
            let retType: UnsafeMutablePointer<Int8> = method_copyReturnType(method)
            
            return (excluded == nil || method_getName(method) != excluded) && strcmp(retType, "B") == 0
        })
        
        if let ret {
            return method_getName(ret)
        }
        
        return nil
    }
}
