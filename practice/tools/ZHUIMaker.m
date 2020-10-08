//
//  ZHUIMaker.m
//  practice
//
//  Created by 张浩 on 2020/10/7.
//  常用ui组件工厂类

#import "ZHUIMaker.h"

@implementation ZHUIMaker
+(UILabel*)ZHCustomLabelWithY:(CGFloat)y{
    return [self ZHCustomLabelWithTextColor:[UIColor lightGrayColor] FontSize:15 y:y];
}

+(UILabel*)ZHCustomLabelWithTextColor:(UIColor*)textColor FontSize:(CGFloat)fontSize y:(CGFloat)y{
    return [self ZHCustomLabelWithTextColor:textColor fontSize:fontSize rect:CGRectMake(0, y, kScreenWidth, 40)];
}
+(UILabel*)ZHCustomLabelWithTextColor:(UIColor*)textColor fontSize:(CGFloat)fontSize rect:(CGRect)rect{
    UILabel* label = [[UILabel alloc]initWithFrame:rect];
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}
@end
