//
//  CustomAccessoryView.h
//  CustomKeyboard
//
//  Created by 未思语 on 14/12/2017.
//  Copyright © 2017 wsy. All rights reserved.
//  键盘辅助视图

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSUInteger, CustomKeyboardType) {
    CustomKeyboardTypeLetter     = 1 << 0,//数字+字母
    CustomKeyboardTypeCharacters = 1 << 1,//字符
    CustomKeyboardTypeNumber     = 1 << 2,//数字
};


typedef void(^typeChangeBlock)(CustomKeyboardType type);
typedef void(^finishBlock)(void);

@interface CustomAccessoryView : UIView
//实例方法
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title type:(CustomKeyboardType)type;
@property (nonatomic, copy) typeChangeBlock typeChange;
@property (nonatomic, copy) finishBlock finish;

@end
