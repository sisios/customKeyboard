//
//  ViewController.m
//  CustomKeyboard
//
//  Created by 未思语 on 14/12/2017.
//  Copyright © 2017 wsy. All rights reserved.
//

#import "ViewController.h"
#import "CustomKeyboard.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 200, 100)];
    textfield.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:textfield];
    CustomInputView *inputview = [CustomInputView createInputViewWithView:textfield title:@"安全键盘" type:CustomKeyboardTypeLetter|CustomKeyboardTypeCharacters|CustomKeyboardTypeNumber radom:YES];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
