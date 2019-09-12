//
//  CodeView.m
//  CodeView
//
//  Created by meb on 2019/9/11.
//  Copyright © 2019 meb. All rights reserved.
//

#import "CodeView.h"

#define margin 12.0 //两个验证码之间的间距 随需求可以更改

@interface CodeView()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * textField;
@property(nonatomic,strong)NSMutableArray <CAShapeLayer *> * shapeArray; //自定义底部线条、边框存放的数组
@property(nonatomic,strong)NSMutableArray <UILabel *> * labelArray; //文字存放的数组
@property(nonatomic,strong)NSMutableArray <CALayer *> * layerArray; //光标数组
@property(nonatomic,assign)NSInteger codeNumber;//验证码输入个数（4或6个）
@property(nonatomic,assign)CGFloat labelFont;//验证码字体大小
@property(nonatomic,strong)UIColor *labelTextColor;//验证码字体颜色
@property(nonatomic,strong)UIColor *mainColor;//光标颜色和输入验证码的边框、线条颜色
@property(nonatomic,strong)UIColor *normalColor;//未选中的颜色
@property(nonatomic,assign)CodeStyle style;//输入框的风格
@end
@implementation CodeView
- (instancetype)initWithFrame:(CGRect)frame codeNumber:(NSInteger)codeNumber style:(CodeStyle)style labelFont:(CGFloat)labelFont labelTextColor:(UIColor *)labelTextColor mainColor:(UIColor *)mainColor normalColor:(UIColor *)normalColor selectCodeBlock:(SelectCodeBlock)CodeBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.codeBlock = CodeBlock;
        self.codeNumber = codeNumber;
        self.style = style;
        self.labelFont = labelFont;
        self.labelTextColor = labelTextColor;
        self.mainColor = mainColor;
        self.normalColor = normalColor;
        [self setUpSubview];
    }
    return self;
}

- (void)setUpSubview {
    //每一个验证码的宽度
    CGFloat width = (CGRectGetWidth(self.bounds) - (self.codeNumber-1)*margin)/self.codeNumber;
    [self addSubview:self.textField];
    self.textField.frame = self.bounds;
    
    for (int i = 0; i < self.codeNumber; i ++) {
        UIView *subView = [[UIView alloc] init];
        subView.frame = CGRectMake((width+margin)*i, 0, width, width);
        subView.userInteractionEnabled = NO;
        subView.layer.cornerRadius = 5 ;
        [self addSubview:subView];
        
        //底部线条、边框的格式
        CALayer *layer = [[CALayer alloc]init];
        if (self.style == CodeStyle_line) {
            layer.frame = CGRectMake(4, width-1, width-8, 1);
            if (i == 0) {
                layer.backgroundColor = self.mainColor.CGColor;
            }else{
                layer.backgroundColor = self.normalColor.CGColor;
            }
            
        }else{
            layer.frame = CGRectMake(0, 0, width, width);
            layer.borderWidth = 0.5;
            layer.cornerRadius = 5;
            layer.backgroundColor = UIColor.whiteColor.CGColor;
            if (i == 0) {
                layer.borderColor = self.mainColor.CGColor;
            }else{
                layer.borderColor = self.normalColor.CGColor;
            }
        }
        [subView.layer addSublayer:layer];
        
        //验证码文字设置
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, width, width);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.labelTextColor;
        label.font = [UIFont systemFontOfSize:self.labelFont];
        label.backgroundColor = UIColor.clearColor;
        [subView addSubview:label];
        //光标
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(width/2, (width/2)-8, 2,16)];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  self.mainColor.CGColor;
        [subView.layer addSublayer:line];
        if (i == 0) {
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            //高亮颜色
            line.hidden = NO;
        }else {
            line.hidden = YES;
        }
        [self.shapeArray addObject:line];
        [self.labelArray addObject:label];
        [self.layerArray addObject:layer];
    }
    [self startEdit];
}

#pragma mark ---- UItextFieldDelegate ----

- (void)textchange:(UITextField *)textField {
    NSString *verStr = textField.text;
    if (verStr.length > self.codeNumber) {
        textField.text = [textField.text substringToIndex:self.codeNumber];
    }
    //当输入内容等于验证码的长度时候，把输入的验证码回调
    if (verStr.length >= self.codeNumber) {
        if (self.codeBlock) {
            self.codeBlock(textField.text);
        }
    }
    //设置文字的显示和光标的移动
    for (int i = 0; i < self.labelArray.count; i ++) {
        UILabel *bgLabel = self.labelArray[i];
        if (i < verStr.length) {
            bgLabel.text = [verStr substringWithRange:NSMakeRange(i, 1)];
        }else {
            bgLabel.text = @"";
        }
        [self changeOpacityAnimalForShapeLayerWithIndex:i shapeArrayHidden:i == verStr.length ? NO : YES];
        [self changeColorForLayerWithIndex:i shapeArrayHidden:i > verStr.length ? NO : YES];
    }
}
//根据文字所在的位置设置底部layer的颜色
- (void)changeColorForLayerWithIndex:(NSInteger)index shapeArrayHidden:(BOOL)hidden {
    CALayer *layer = self.layerArray[index];
    if (hidden) {
        if (self.style == CodeStyle_line) {
            layer.backgroundColor = self.mainColor.CGColor;
        }else{
            layer.borderColor =self.mainColor.CGColor;
        }
    }else{
        if (self.style == CodeStyle_line) {
           layer.backgroundColor = self.normalColor.CGColor;
        }else{
            layer.borderColor = self.normalColor.CGColor;
        }
    }
}

//根据文字所在的位置改变光标的位置
- (void)changeOpacityAnimalForShapeLayerWithIndex:(NSInteger)index shapeArrayHidden:(BOOL)hidden {
    CAShapeLayer *line = self.shapeArray[index];
    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
        
    }else{
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    [UIView animateWithDuration:0.25 animations:^{
        line.hidden = hidden;
    }];
}
//开始编辑
- (void)startEdit{
    [self.textField becomeFirstResponder];
}
//结束编辑
- (void)endEdit{
    [self.textField resignFirstResponder];
}

#pragma mark ---- lazy ----
//闪动动画
- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}
- (NSMutableArray *)shapeArray {
    if (!_shapeArray) {
        _shapeArray = [NSMutableArray array];
    }
    return _shapeArray;
}
- (NSMutableArray *)layerArray {
    if (!_layerArray) {
        _layerArray= [NSMutableArray array];
    }
    return _layerArray;
}
- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.tintColor = [UIColor clearColor];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor clearColor];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField addTarget:self action:@selector(textchange:) forControlEvents:UIControlEventEditingChanged];
        if (@available(iOS 12.0, *)) {
            //Xcode 10 适配
            self.textField.textContentType = UITextContentTypeOneTimeCode;
        }
    }
    return _textField;
}

@end
