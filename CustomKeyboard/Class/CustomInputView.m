//
//  CustomInputView.m
//  CustomKeyboard
//
//  Created by 未思语 on 14/12/2017.
//  Copyright © 2017 wsy. All rights reserved.
//

#import "CustomInputView.h"
#import "UITextField+SecurityText.h"
#import "CustomKeyboardCell.h"

// 数据宏
#define NUMBER @"1234567890"
#define LETTER @"qwertyuiopasdfghjklzxcvbnm"
#define SPECIAL_CHARACTER @"!@#$%^&*()'\"=_:;?~|`+-\\/[]{},.<>"
#define POT @"."
#define ALT @"alt"
#define IDENTIFIER @"identifier"
#define SPACE_PADDING 3.0 //边框距离
#define ITEM_HEIGTH ITEM_WIDHT*4/3
#define ITEM_WIDHT (CGRectGetWidth([UIScreen mainScreen].bounds)-SPACE_PADDING*11)/10
#define MAX_ITEM_WIDTH (CGRectGetWidth([UIScreen mainScreen].bounds)-SPACE_PADDING*4)/3
#define DELETE NSLocalizedStringFromTable(@"del", @"File", nil)
#define SPACE  NSLocalizedStringFromTable(@"space", @"File", nil)
#define BACKGROUND_COLOR [UIColor colorWithWhite:61./255 alpha:1]
#define ITEM_COLOR [UIColor colorWithWhite:118./255 alpha:1]
#define ITEM_DARK_COLOR [UIColor colorWithWhite:83./255 alpha:1]


@interface CustomInputView() <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *mainView;

@property (nonatomic, strong) NSMutableArray *datasource;//数据源 将字符串转化成数组中的对象
@property (nonatomic, assign) NSUInteger length; // 文本限制长度
@property (nonatomic, assign) BOOL radom; //是否是随机显示
@property (nonatomic, strong) UITextField <UIKeyInput>*textfield;
@property (nonatomic, assign) BOOL uppercase;// 是否是大小写
@property (nonatomic, assign) CustomKeyboardType currentType;//记录当前是哪种类型
@property (nonatomic, strong) NSArray *numbers;// 纯数字
@property (nonatomic, strong) NSArray *letters;// 数字+字母
@property (nonatomic, strong) NSArray *specialCharaters;//纯字符



@end
@implementation CustomInputView
-(instancetype)initWithView:(UIView<UIKeyInput> *)view title:(NSString *)title type:(CustomKeyboardType)type radom:(BOOL)random {
    return [self initWithView:view title:title type:type radom:random length:-1];
   
    
}
-(instancetype)initWithView:(UIView<UIKeyInput> *)view title:(NSString *)title type:(CustomKeyboardType)type radom:(BOOL)random length:(NSUInteger)length {
    self = [super init];
    if (self) {
        self.length = length;
        self.radom = random;
        [view setValue:self forKey:@"inputView"];
        self.textfield = (UITextField *)view;
        CustomAccessoryView *accessoryView = [[CustomAccessoryView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 40) title:title?title:@"安全键盘" type:type];
        accessoryView.backgroundColor = [UIColor darkGrayColor];
        __weak typeof(self) weakself = self;
        accessoryView.finish = ^{
            [weakself.textfield resignFirstResponder];
        };
        accessoryView.typeChange = ^(CustomKeyboardType type) {
            [weakself reloadKeyboardWithType:type];
        };
        [self.textfield setValue:accessoryView forKey:@"inputAccessoryView"];
        if (random) {
            self.numbers = [self random:[self getArrWithStr:NUMBER]];
            self.specialCharaters = [self random:[self getArrWithStr:SPECIAL_CHARACTER]];
            self.letters = [self random:[self getArrWithStr:LETTER]];
        } else{
            self.numbers = [self getArrWithStr:NUMBER];
            self.letters = [self getArrWithStr:LETTER];
            self.specialCharaters = [self getArrWithStr:SPECIAL_CHARACTER];
        }
        self.uppercase = NO;
        self.frame = CGRectMake(0, 0,CGRectGetWidth([UIScreen mainScreen].bounds),SPACE_PADDING*5+ITEM_HEIGTH*4);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        self.mainView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        self.mainView.backgroundColor = BACKGROUND_COLOR;
        self.mainView.delegate = self;
        self.mainView.dataSource = self;
        [self.mainView registerClass:[CustomKeyboardCell class] forCellWithReuseIdentifier:IDENTIFIER];
        [self addSubview:self.mainView];
        [self reloadKeyboardWithType:type];
        
        
    }
    return self;
    
}
+(instancetype)createInputViewWithView:(UIView<UIKeyInput> *)view title:(NSString *)title type:(CustomKeyboardType)type radom:(BOOL)random {
    CustomInputView *inputview = [[CustomInputView alloc]initWithView:view title:title type:type radom:random length:-1];
    return inputview;
}
+(instancetype)createInputViewWithView:(UIView<UIKeyInput> *)view title:(NSString *)title type:(CustomKeyboardType)type radom:(BOOL)random length:(NSUInteger)length {
    CustomInputView *inputview = [[CustomInputView alloc]initWithView:view title:title type:type radom:random length:length];
    return inputview;
}

-(NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}
//将字符串转化成数组数据
- (NSArray *)getArrWithStr:(NSString *)str {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        [arr addObject:[str substringWithRange:NSMakeRange(i, 1)]];
    }
    return arr;
}
///随机排序
-(NSArray *)random:(NSArray *)arr{
    NSArray *x = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    return x;
}

//刷新数据源
- (void)reloadKeyboardWithType:(CustomKeyboardType)type {
    if (type & CustomKeyboardTypeNumber) {//纯数字
        self.currentType = CustomKeyboardTypeNumber;
        [self.datasource removeAllObjects];
        [self.datasource addObjectsFromArray:self.numbers];
        [self.datasource insertObject:POT atIndex:9];
        [self.datasource addObject:DELETE];
        [self.mainView reloadData];
    } else if (type & CustomKeyboardTypeCharacters) {//纯字符
        self.currentType = CustomKeyboardTypeCharacters;
        [self.datasource removeAllObjects];
        [self.datasource addObjectsFromArray:self.specialCharaters];
        [self.datasource addObject:SPACE];
        [self.datasource addObject:DELETE];
        [self.mainView reloadData];
        
    } else if (type & CustomKeyboardTypeLetter) {// 数字+字母
        self.currentType = CustomKeyboardTypeLetter;
        [self.datasource removeAllObjects];
        [self.datasource addObjectsFromArray:self.numbers];
        [self.datasource addObjectsFromArray:self.letters];
        [self.datasource insertObject:ALT atIndex:20];
        [self.datasource insertObject:SPACE atIndex:30];
        [self.datasource  addObject:DELETE];
        [self.mainView reloadData];
    }
}
#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}
//cell显示样式
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomKeyboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER forIndexPath:indexPath];
    NSString *item = self.datasource[indexPath.row];
    cell.textLabel.text = item;
    if ([item isEqualToString:DELETE] || [item isEqualToString:SPACE] || [item isEqualToString:ALT]) {
        cell.backgroundColor = ITEM_DARK_COLOR;
    } else {
        cell.backgroundColor = ITEM_COLOR;
    }
    if (self.uppercase && (self.currentType & CustomKeyboardTypeLetter)) {
        cell.textLabel.text = [item uppercaseString];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[UIDevice currentDevice] playInputClick];// 点击键盘之后的声音控制
    NSString *text = self.datasource[indexPath.row];
    if ([text isEqualToString:DELETE]) {// 点击删除键
        if ([self.textfield hasText]) {
            [self.textfield deleteBackward];
            NSMutableString *tmpstr = [NSMutableString stringWithString:self.textfield.securityText];
            self.textfield.securityText = [tmpstr substringToIndex:tmpstr.length-1];
        }
    } else if ([text isEqualToString:SPACE]) {//点击空格
        [self.textfield insertText:@"*"];
        NSMutableString *tmpstr = [NSMutableString stringWithString:self.textfield.securityText];
        [tmpstr appendString:@" "];
        self.textfield.securityText = [NSString stringWithString:tmpstr];
    } else if ([text isEqualToString:ALT]){// 点击大小写切换
        self.uppercase = !self.uppercase;
        [self.mainView reloadData];
    
    } else {
        //限制输入框的输入长度
        if (self.textfield.securityText.length == self.length) {
            return;
        }
        [self.textfield insertText:@"*"];
        NSMutableString *tmpstr = [NSMutableString stringWithString:self.textfield.securityText];
        [tmpstr appendString:text];
        self.textfield.securityText = [NSString stringWithString:tmpstr];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *item = self.datasource[indexPath.row];
    if (self.currentType & CustomKeyboardTypeNumber) {
        return CGSizeMake(MAX_ITEM_WIDTH, ITEM_HEIGTH);
    } else if (self.currentType & CustomKeyboardTypeLetter) {
        if ([item isEqualToString:SPACE] || [item isEqualToString:DELETE]) {
            return CGSizeMake(ITEM_WIDHT +SPACE_PADDING + (ITEM_WIDHT-SPACE_PADDING)/2, ITEM_HEIGTH);;
        } else {
            return CGSizeMake(ITEM_WIDHT, ITEM_HEIGTH);
        }
    } else if (self.currentType & CustomKeyboardTypeCharacters) {
        if ([item isEqualToString:SPACE]) {
            return CGSizeMake((ITEM_WIDHT+SPACE_PADDING)*6+(ITEM_WIDHT-SPACE_PADDING)/2, ITEM_HEIGTH);
        } else if ([item isEqualToString:DELETE]) {
            return CGSizeMake(ITEM_WIDHT+SPACE_PADDING+(ITEM_WIDHT-SPACE_PADDING)/2, ITEM_HEIGTH);
        }
    }
    return CGSizeMake(ITEM_WIDHT, ITEM_HEIGTH);
 
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(SPACE_PADDING, SPACE_PADDING, SPACE_PADDING, SPACE_PADDING);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return SPACE_PADDING;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return SPACE_PADDING-0.001;
}



@end
