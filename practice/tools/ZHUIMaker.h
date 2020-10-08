//
//  ZHUIMaker.h
//  practice
//
//  Created by 张浩 on 2020/10/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface ZHUIMaker : NSObject
+(UILabel*)ZHCustomLabelWithY:(CGFloat)y;
+(UILabel*)ZHCustomLabelWithTextColor:(UIColor*)textColor FontSize:(CGFloat)fontSize y:(CGFloat)y;
+(UILabel*)ZHCustomLabelWithTextColor:(UIColor*)textColor fontSize:(CGFloat)fontSize rect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
