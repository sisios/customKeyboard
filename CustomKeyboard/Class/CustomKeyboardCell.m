//
//  CustomKeyboardCell.m
//  CustomKeyboard
//
//  Created by 未思语 on 14/12/2017.
//  Copyright © 2017 wsy. All rights reserved.
//

#import "CustomKeyboardCell.h"

@implementation CustomKeyboardCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor darkTextColor];
        _textLabel = [[UILabel alloc]init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_textLabel];
        NSArray *constraints1 =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)];
        NSArray *constraints2 =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)];
        [self addConstraints:constraints1];
        [self addConstraints:constraints2];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2.5;
    }
    return self;
    
}
@end
