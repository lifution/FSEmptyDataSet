//
//  FSEmptyViewDefines.h
//  FSEmptyDataSet
//
//  Created by Sheng on 2018/4/25.
//  Copyright © 2018 fusheng. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static inline BOOL FSEmptyReplaceMethod(Class _class, SEL _originSelector, SEL _newSelector) {
    Method oriMethod = class_getInstanceMethod(_class, _originSelector);
    Method newMethod = class_getInstanceMethod(_class, _newSelector);
    if (!newMethod) {
        return NO;
    }
    BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
    return YES;
}
