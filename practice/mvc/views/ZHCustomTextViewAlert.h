//
//  ZHCustomTextViewAlert.h
//  practice
//
//  Created by 张浩 on 2020/12/26.
//

#import "BaseView.h"
typedef  void(^ZHCustomAlertCallBackBlock)(BOOL);
NS_ASSUME_NONNULL_BEGIN

@interface ZHCustomTextViewAlert : BaseView
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* textInfo;
@property(nonatomic,copy)ZHCustomAlertCallBackBlock confirmCallBack;
@property(nonatomic,copy)ZHCustomAlertCallBackBlock cancelCallBack;

-(void)showAlertInView:(UIView*)superView;
+(void)showAlertInView:(UIView*)superView WithText:(NSString*)text;
+(void)showAlertInView:(UIView*)superView WithTitle:(NSString*)title text:(NSString*)text;
+(void)showAlertInView:(UIView*)superView WithTitle:(NSString*)title text:(NSString*)text confirmBlock:(ZHCustomAlertCallBackBlock)confirmBlock
           cancelBlock:(ZHCustomAlertCallBackBlock)canCelBlock;
+(instancetype)customAlertViewWithText:(NSString*)text;
+(instancetype)customAlertViewWithTitle:(NSString*)title text:(NSString*)text;
+(instancetype)customAlertViewWithTitle:(nullable NSString*)title
                                   text:(nullable NSString*)text
                           confirmBlock:(nullable ZHCustomAlertCallBackBlock)confirmBlock
                            cancelBlock:(nullable ZHCustomAlertCallBackBlock)canCelBlock;
@end

NS_ASSUME_NONNULL_END
