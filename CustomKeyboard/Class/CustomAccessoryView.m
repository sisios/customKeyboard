//
//  CustomAccessoryView.m
//  CustomKeyboard
//
//  Created by 未思语 on 14/12/2017.
//  Copyright © 2017 wsy. All rights reserved.
//

#import "CustomAccessoryView.h"
#define KEYBOARD_TYPE_LETTER @"Abc" //数字+字母
#define KEYBOARD_TYPE_CHARACTRER @"#+=" //纯字符
#define KEYBOARD_TYPE_NUMBER @"123" //纯数字

@interface CustomAccessoryView ()
{
    UIButton *typeButton;
    UILabel *titleLabel;
    UIButton *finishButton;
    
    NSMutableArray *titles;//存放所有的键盘对应的字符
    
    
}
@end

@implementation CustomAccessoryView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
    
}
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title type:(CustomKeyboardType)type {
    self = [super initWithFrame:frame];
    if (self) {
        titles = [NSMutableArray array];
       
        if ((type &CustomKeyboardTypeNumber)) {
            [titles addObject:KEYBOARD_TYPE_NUMBER];
        }
        if (type &CustomKeyboardTypeLetter) {
            [titles addObject:KEYBOARD_TYPE_LETTER];
        }
        if (type &CustomKeyboardTypeCharacters) {
            [titles addObject:KEYBOARD_TYPE_CHARACTRER];
        }
        
        typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        typeButton.frame = CGRectMake(10, 0, frame.size.height,frame.size.height);
        [typeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [typeButton addTarget:self action:@selector(typeChange:) forControlEvents:UIControlEventTouchUpInside];
        if (titles.count > 1) {
            [typeButton setTitle:[titles objectAtIndex:1] forState:UIControlStateNormal];
        }
        [self addSubview:typeButton];
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake((frame.size.width-100)/2, 0, 100, frame.size.height);
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        titleLabel.textColor = [UIColor redColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        finishButton.frame = CGRectMake(self.frame.size.width-10-frame.size.height, 0, frame.size.height,frame.size.height);
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [finishButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishButton];
        
        
    }
    return self;
    
}
- (void)typeChange:(UIButton *)sender {
    NSString *text = [sender titleForState:UIControlStateNormal];
    NSUInteger currentIndex = [titles indexOfObject:text];
    NSUInteger  nextIndex = (currentIndex+1)% titles.count;
    [sender setTitle:[titles objectAtIndex:nextIndex] forState:UIControlStateNormal];
    if (self.typeChange) {
        self.typeChange([self getTypeWithText:text]);
    }

}
//根据title返回不同的键盘类型
- (CustomKeyboardType)getTypeWithText:(NSString *)text {
    if ([text isEqualToString:KEYBOARD_TYPE_LETTER]) {
        return CustomKeyboardTypeLetter;
    } else if ([text isEqualToString:KEYBOARD_TYPE_CHARACTRER]) {
        return  CustomKeyboardTypeCharacters;
    } else if ([text isEqualToString:KEYBOARD_TYPE_NUMBER]) {
        return CustomKeyboardTypeNumber;
    }
    return CustomKeyboardTypeLetter;
}
- (void)finish:(UIButton *)sender {
    if (self.finish) {
        self.finish();
    }
}
-(void)setTypeChange:(typeChangeBlock)typeChange {
    _typeChange = [typeChange copy];
}
-(void)setFinish:(finishBlock)finish {
    _finish = [finish copy];
    
}


@end
