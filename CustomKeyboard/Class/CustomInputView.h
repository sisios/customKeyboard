//
//  CustomInputView.h
//  CustomKeyboard
//
//  Created by 未思语 on 14/12/2017.
//  Copyright © 2017 wsy. All rights reserved.
//  键盘视图

#import <UIKit/UIKit.h>
#import "CustomAccessoryView.h"

@interface CustomInputView : UIView

-(instancetype)initWithView:(UIView<UIKeyInput>*)view title:(NSString *)title type:(CustomKeyboardType) type radom:(BOOL)random;
/**
 实例方法
 @paramter view 相关联的输入view textfield
 @paramter title accessoryView title文字
 @paramter type 键盘显示类型
 @paramter radom 是否是随机显示
 @paramter length 限制输入长度
 return 实例
 
 */
-(instancetype)initWithView:(UIView<UIKeyInput>*)view title:(NSString *)title type:(CustomKeyboardType) type radom:(BOOL)random length:(NSUInteger)length;
+(instancetype)createInputViewWithView:(UIView<UIKeyInput>*)view title:(NSString *)title type:(CustomKeyboardType )type radom:(BOOL)random;
+(instancetype)createInputViewWithView:(UIView<UIKeyInput>*)view title:(NSString *)title type:(CustomKeyboardType )type radom:(BOOL)random length:(NSUInteger)length;


@end

