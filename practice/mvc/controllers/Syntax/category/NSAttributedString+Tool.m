//
//  NSAttributedString+Tool.m
//  practice
//
//  Created by 张浩 on 2020/12/27.
//

#import "NSAttributedString+Tool.h"

@implementation NSAttributedString (Tool)
+(CGFloat)returnHeightWithFont:(UIFont *)font andWidth:(CGFloat)width  andText:(NSString *)text
{
   
   NSAttributedString *atr= [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    //设定attributedString的字体及大小，一定要设置这个，否则计算出来的height是非常不准确的
    //NSMutableDictionary *attDic = [NSMutableDictionary dictionary];
   // attDic setObject:font forKey:<#(nonnull id<NSCopying>)#>
    
   // [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, self.length)];
    
    //计算attributedString的rect
    
    CGRect  contentRect = [atr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return contentRect.size.height;

}

+(CGFloat)labelHeightWithFont:(UIFont *)font andWidth:(CGFloat)width andText:(NSString *)titleContent{
    
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize.height;
    
}

/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGFloat) heightForString:(UITextView *)textView andWidth:(CGFloat)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param attStr 多属性字符串
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGFloat) heightForAttributedString:(NSAttributedString *)attStr andWidth:(CGFloat)width{
    
    UITextView* textView = [[UITextView alloc]initWithFrame:CGRectZero];
    textView.attributedText = attStr;
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}



#pragma mark zhanghao Add

//带有行间距的字符串
+(NSMutableAttributedString*)haveInterValLabelStrWithString:(NSString*)str
                                                lineSpacing:(CGFloat)lineSpacing{
    if(!str&&![str isKindOfClass:[NSString class]]){
        return nil;
    }
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lineSpacing];//行间距
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    [attributedString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [str length])];
    
    return attributedString1;
    
}
+(NSMutableAttributedString*)haveLineLabelWithString:(NSString*)oneString
                                           subString:(NSArray*)subSutrings
                                                Font:(UIFont*)baseFont
                                             subFont:(UIFont*)subFont
                                               color:(UIColor*)color
{
    
    if (subSutrings==nil||subSutrings.count==0) {
        subSutrings = @[@""];
    }
    if (oneString.length<[subSutrings componentsJoinedByString:@""].length) {
        return nil;
    }
    /*设置多属性字符串*/
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString:oneString];
    NSUInteger length = [oneString length];
    // 设置基本字体
    [attrString addAttribute:NSFontAttributeName value:baseFont
                       range:NSMakeRange(0, length)];
    
    for (int i=0; i< subSutrings.count; i++) {
        NSString* subSutring = [subSutrings objectAtIndex:i];
        [attrString addAttribute:NSFontAttributeName value:subFont range:[oneString rangeOfString:subSutring]];
        // 设置颜色
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:color
                           range:[oneString rangeOfString:subSutring]];
        
        [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid) range:[oneString rangeOfString:subSutring]];
        
        [attrString addAttribute:NSStrikethroughColorAttributeName value:color range:[oneString rangeOfString:subSutring]];
    }
    
    return attrString;
    
}
+(NSMutableAttributedString*)createMutableAttributedStringWithString:(NSString*)oneString
                                                           subString:(NSArray*)subSutrings
                                                                Font:(UIFont*)baseFont
                                                             subFont:(UIFont*)subFont
                                                               color:(UIColor*)color{
    
    if (oneString==nil||[oneString isKindOfClass:[NSNull class]]) {
        oneString = @"";
    }
    if (subSutrings==nil||subSutrings.count==0) {
        subSutrings = @[@""];
    }
    if (oneString.length<[subSutrings componentsJoinedByString:@""].length) {
        return nil;
    }
    /*设置多属性字符串*/
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString:oneString];
    NSUInteger length = [oneString length];
    // 设置基本字体
    [attrString addAttribute:NSFontAttributeName value:baseFont
                       range:NSMakeRange(0, length)];
    for (int i=0; i< subSutrings.count; i++) {
        NSString* subSutring = [subSutrings objectAtIndex:i];
        [attrString addAttribute:NSFontAttributeName value:subFont range:[oneString rangeOfString:subSutring]];
        // 设置颜色
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:color
                           range:[oneString rangeOfString:subSutring]];
    }
    
    return attrString;
}
+(NSMutableAttributedString*)createMutableAttributedStringWithAttributedString:(NSMutableAttributedString*)oneString
                                                                     subString:(NSArray*)subSutrings
                                                                          Font:(UIFont*)baseFont
                                                                       subFont:(UIFont*)subFont
                                                                         color:(UIColor*)color{
    
    
    if (oneString==nil||[oneString isKindOfClass:[NSNull class]]) {
        oneString = [[NSMutableAttributedString alloc]initWithString:@""];
    }
    if (subSutrings==nil||subSutrings.count==0) {
        subSutrings = @[@""];
    }
    if (oneString.length<[subSutrings componentsJoinedByString:@""].length) {
        return nil;
    }
    /*设置多属性字符串*/
    NSMutableAttributedString* attrString = [oneString mutableCopy];
    
    NSUInteger length = [oneString length];
    // 设置基本字体
    [attrString addAttribute:NSFontAttributeName value:baseFont
                       range:NSMakeRange(0, length)];
    for (int i=0; i< subSutrings.count; i++) {
        NSString* subSutring = [subSutrings objectAtIndex:i];
        [attrString addAttribute:NSFontAttributeName value:subFont range:[oneString.string rangeOfString:subSutring]];
        // 设置颜色
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:color
                           range:[oneString.string rangeOfString:subSutring]];
    }
    
    return attrString;
}


+(NSMutableAttributedString*)hasImageText:(NSString*)text
                                     font:(UIFont*)font
                                textColor:(UIColor*)textColor
                                    image:(NSString*)imageName
                               imageFrame:(CGRect)imageFrame
                                    index:(NSInteger)index{
    if (text==nil || [text isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSString* realText = [NSString stringWithFormat:@" %@",text];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:realText];
    
    // 修改富文本中的不同文字的样式
    [attri addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, realText.length)];
    [attri addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, realText.length)];
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:imageName];
    // 设置图片大小
    attch.bounds =imageFrame;
    
    // 创建带有图片的富文本
    NSAttributedString *m_string = [NSAttributedString attributedStringWithAttachment:attch];
    //    [attri appendAttributedString:string];
    [attri insertAttributedString:m_string atIndex:index];
    
    // 用label的attributedText属性来使用富文本
    return attri;
}

@end
