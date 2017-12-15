
//
//  UITextField+SecurityText.m
//  CustomKeyboard
//
//  Created by 未思语 on 14/12/2017.
//  Copyright © 2017 wsy. All rights reserved.
//

#import "UITextField+SecurityText.h"
#import <objc/runtime.h>
static char key;

@implementation UITextField (SecurityText)
-(void)setSecurityText:(NSString *)securityText {
    objc_setAssociatedObject(self, key, securityText, OBJC_ASSOCIATION_RETAIN);
}
-(NSString *)securityText {
    NSString *x = objc_getAssociatedObject(self, key);
    if (!x.length) {
        return @"";
    } else {
        return x;
    }
    
}
@end
