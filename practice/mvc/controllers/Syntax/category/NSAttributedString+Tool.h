//
//  NSAttributedString+Tool.h
//  practice
//
//  Created by 张浩 on 2020/12/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Tool)
+(CGFloat)returnHeightWithFont:(UIFont *) font andWidth:(CGFloat) width andText:(NSString *)text;
+(CGFloat)labelHeightWithFont:(UIFont *)font andWidth:(CGFloat)width andText:(NSString *)titleContent;
+(CGFloat) heightForString:(UITextView *)textView andWidth:(CGFloat)width;

/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param attStr 多属性字符串
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGFloat) heightForAttributedString:(NSAttributedString *)attStr andWidth:(CGFloat)width;



/**
 获取多属性字符串
 
 @param text 文字
 @param font 字体
 @param textColor 字体颜色
 @param imageName 小图片
 @param imageFrame 图片大小
 @return 多属性字符串
 */
+(NSMutableAttributedString*)hasImageText:(NSString*)text
                                     font:(UIFont*)font
                                textColor:(UIColor*)textColor
                                    image:(NSString*)imageName
                               imageFrame:(CGRect)imageFrame
                                    index:(NSInteger)index;


//带有行间距的字符串
+(NSMutableAttributedString*)haveInterValLabelStrWithString:(NSString*)str
                                                lineSpacing:(CGFloat)lineSpacing;

+(NSMutableAttributedString*)haveLineLabelWithString:(NSString*)oneString
                                           subString:(NSArray*)subSutrings
                                                Font:(UIFont*)baseFont
                                             subFont:(UIFont*)subFont
                                               color:(UIColor*)color;

+(NSMutableAttributedString*)createMutableAttributedStringWithString:(NSString*)oneString
                                                           subString:(NSArray*)subSutrings
                                                                Font:(UIFont*)baseFont
                                                             subFont:(UIFont*)subFont
                                                               color:(UIColor*)color;
+(NSMutableAttributedString*)createMutableAttributedStringWithAttributedString:(NSMutableAttributedString*)oneString
                                                                     subString:(NSArray*)subSutrings
                                                                          Font:(UIFont*)baseFont
                                                                       subFont:(UIFont*)subFont
                                                                         color:(UIColor*)color;


@end

NS_ASSUME_NONNULL_END
