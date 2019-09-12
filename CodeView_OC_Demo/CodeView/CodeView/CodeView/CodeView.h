//
//  CodeView.h
//  CodeView
//
//  Created by meb on 2019/9/11.
//  Copyright © 2019 meb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CodeStyle) {
    CodeStyle_line, //下划线格式
    CodeStyle_border //带边框格式
};
typedef void(^SelectCodeBlock)(NSString *);
@interface CodeView : UIView
@property(nonatomic,copy)SelectCodeBlock codeBlock;//验证码回调
- (instancetype)initWithFrame:(CGRect)frame codeNumber:(NSInteger)codeNumber style:(CodeStyle)style labelFont:(CGFloat)labelFont labelTextColor:(UIColor *)labelTextColor mainColor:(UIColor *)mainColor normalColor:(UIColor *)normalColor selectCodeBlock:(SelectCodeBlock)CodeBlock;
- (void)startEdit;
- (void)endEdit;
@end

NS_ASSUME_NONNULL_END
