//
//  ZHCustomTextViewAlert.m
//  practice
//
//  Created by 张浩 on 2020/12/26.
//

#import "ZHCustomTextViewAlert.h"
#import "NSAttributedString+Tool.h"
#import <WebKit/WebKit.h>
#define kAlertContentMarginX 5
#define kAlertContentMarginY 100
#define kAlertContentWidth (kMainScreenWidth - kAlertContentMarginX*2)
#define kAlertContentHeight (kMainScreenHeight - kAlertContentMarginY*2)

@interface ZHCustomTextViewAlert()
@property(nonatomic,strong)UITextView* contentText;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* confirmButton;
@property(nonatomic,strong)UIButton* cancelButton;
@property(nonatomic,strong)UIView* contentView;
@property(nonatomic,strong)WKWebView* webContentView;
@end
static NSInteger AnimationCount = 0;
@implementation ZHCustomTextViewAlert
-(void)showAlertInView:(UIView*)superView{
    [UIView animateWithDuration:2 animations:^{
        [superView addSubview:self];
    }];
}
+(void)showAlertInView:(UIView*)superView WithText:(NSString*)text{
    [self showAlertInView:superView WithTitle:@"" text:text confirmBlock:nil cancelBlock:nil];
}
+(void)showAlertInView:(UIView*)superView WithTitle:(NSString*)title text:(NSString*)text{
    [self showAlertInView:superView WithTitle:title text:text confirmBlock:nil cancelBlock:nil];
}
+(void)showAlertInView:(UIView*)superView WithTitle:(NSString*)title text:(NSString*)text confirmBlock:(ZHCustomAlertCallBackBlock)confirmBlock
           cancelBlock:(ZHCustomAlertCallBackBlock)canCelBlock{
    ZHCustomTextViewAlert* alert = [ZHCustomTextViewAlert customAlertViewWithTitle:title text:text confirmBlock:confirmBlock cancelBlock:canCelBlock];
    [alert setAlpha:0.1];
    alert.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [superView addSubview:alert];
    [UIView animateWithDuration:0.4 animations:^{
        alert.transform = CGAffineTransformMakeScale(1, 1);
        [alert setAlpha:1];
    }];
}
+(instancetype)customAlertViewWithText:(NSString*)text{
    
    return  [self customAlertViewWithTitle:@"" text:text];
    
}
+(instancetype)customAlertViewWithTitle:(NSString*)title text:(NSString*)text{

    return  [self customAlertViewWithTitle:title text:text confirmBlock:nil cancelBlock:nil];
}
+(instancetype)customAlertViewWithTitle:(NSString*)title
                                   text:(NSString*)text
                           confirmBlock:(ZHCustomAlertCallBackBlock)confirmBlock
                            cancelBlock:(ZHCustomAlertCallBackBlock)canCelBlock{
    
    ZHCustomTextViewAlert* alert =[[ZHCustomTextViewAlert alloc]init];
    alert.title = title;
    alert.textInfo = text;
    alert.confirmCallBack = confirmBlock;
    alert.cancelCallBack = canCelBlock;
    return  alert;
}
-(instancetype)init{
    CGRect frame = [UIScreen mainScreen].bounds;
    return [self initWithFrame:frame];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentText];
        [self.contentView addSubview:self.confirmButton];
        [self.contentView addSubview:self.cancelButton];
    }
    return self;
}
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
-(void)setTextInfo:(NSString *)textInfo{
    NSURL* url = [NSURL URLWithString:textInfo];
    if (url) {
        [self.contentView addSubview:self.webContentView];
        [self.webContentView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
    self.contentText.attributedText = [NSAttributedString haveInterValLabelStrWithString:textInfo lineSpacing:8];;
}
-(UIView*)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(kAlertContentMarginX, kAlertContentMarginY, kAlertContentWidth, kAlertContentHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.f;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;;
}

-(UILabel*)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kAlertContentWidth, 40)];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"提示";
    }
    return _titleLabel;
}

-(UITextView*)contentText{
    if (_contentText == nil) {
        _contentText = [[UITextView alloc]initWithFrame:CGRectMake(5, 40, kAlertContentWidth-10, kAlertContentHeight-80)];
        _contentText.font = [UIFont systemFontOfSize:15.f];
        _contentText.backgroundColor = [UIColor whiteColor];
        _contentText.editable = NO;
    }
    return _contentText;
}
-(WKWebView*)webContentView{
    if (_webContentView == nil) {
        // js配置
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        
        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        _webContentView = [[WKWebView alloc]initWithFrame:CGRectMake(5, 40, kAlertContentWidth-10, kAlertContentHeight-80) configuration:configuration];
    }
    return _webContentView;
}
-(UIButton*)confirmButton{
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setFrame:CGRectMake(kAlertContentWidth/2, kAlertContentHeight-40, kAlertContentWidth/2, 40.f)];
        [_confirmButton setBackgroundColor:[UIColor clearColor]];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateHighlighted];
        [_confirmButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateHighlighted];
        [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.borderColor = [UIColor grayColor].CGColor;
        _confirmButton.layer.borderWidth = 0.5;
    }
    return _confirmButton;
}

-(UIButton*)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setFrame:CGRectMake(0, kAlertContentHeight-40, kAlertContentWidth/2, 40.f)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];
        [_cancelButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateHighlighted];
        [_cancelButton setBackgroundColor:[UIColor clearColor]];
        _cancelButton.layer.borderColor = [UIColor grayColor].CGColor;
        _cancelButton.layer.borderWidth = 0.5;
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(void)confirmAction{
    if (self.confirmCallBack) {
        self.confirmCallBack(YES);
    }
    [self dismiss];
}
-(void)cancelAction{
    if (self.cancelCallBack) {
        self.cancelCallBack(NO);
    }
    [self dismiss];
}
-(void)dismiss{
    AnimationCount++;
    if (AnimationCount > 24) {
        AnimationCount = 0;
    }
    UIViewAnimationOptions option = [self getAminationOptions];
    [UIView animateWithDuration:0.4f delay:0.1 options:option animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [[self layer] removeAllAnimations];
        [self removeFromSuperview];
    }];
}
//- (void)restoreAnimations {
//
//    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear animations:^{
//        [self setAlpha: 1.0f];
//    } completion:NULL];
//}
-(UIViewAnimationOptions)getAminationOptions{
    NSArray* array =@[@(UIViewAnimationOptionLayoutSubviews), //           = 1 <<  0,
                     @(UIViewAnimationOptionAllowUserInteraction), //       = 1 <<  1, // turn on user interaction while animating
                     @(UIViewAnimationOptionBeginFromCurrentState), //      = 1 <<  2, // start all views from current value, not initial value
                     @(UIViewAnimationOptionRepeat), //    无法停止            = 1 <<  3, // repeat animation indefinitely
                     @(UIViewAnimationOptionAutoreverse), //                = 1 <<  4, // if repeat, run animation back and forth
                     @(UIViewAnimationOptionOverrideInheritedDuration), //  = 1 <<  5, // ignore nested duration
                     @(UIViewAnimationOptionOverrideInheritedCurve), //     = 1 <<  6, // ignore nested curve
                     @(UIViewAnimationOptionAllowAnimatedContent), //       = 1 <<  7, // animate contents (applies to transitions only)
                     @(UIViewAnimationOptionShowHideTransitionViews), //    = 1 <<  8, // flip to/from hidden state instead of adding/removing
                     @(UIViewAnimationOptionOverrideInheritedOptions), //   = 1 <<  9, // do not inherit any options or animation type
                     @(UIViewAnimationOptionCurveEaseInOut), //             = 0 << 16, // default
                     @(UIViewAnimationOptionCurveEaseIn), //              = 1 << 16,
                     @(UIViewAnimationOptionCurveEaseOut), //               = 2 << 16,
                     @(UIViewAnimationOptionCurveLinear), //                = 3 << 16,
                     @(UIViewAnimationOptionTransitionNone), //             = 0 << 20, // default
                     @(UIViewAnimationOptionTransitionFlipFromLeft), //     = 1 << 20,
                     @(UIViewAnimationOptionTransitionFlipFromRight), //    = 2 << 20,
                     @(UIViewAnimationOptionTransitionCurlUp), //           = 3 << 20,
                     @(UIViewAnimationOptionTransitionCurlDown), //         = 4 << 20,
                     @(UIViewAnimationOptionTransitionCrossDissolve), //    = 5 << 20,
                     @(UIViewAnimationOptionTransitionFlipFromTop), //      = 6 << 20,
                     @(UIViewAnimationOptionTransitionFlipFromBottom), //   = 7 << 20,
                     @(UIViewAnimationOptionPreferredFramesPerSecondDefault), //      = 0 << 24,
                     @(UIViewAnimationOptionPreferredFramesPerSecond60), //           = 3 << 24,
                     @(UIViewAnimationOptionPreferredFramesPerSecond30)];
    NSNumber* option = array[AnimationCount];
    if([option isEqualToNumber:@(UIViewAnimationOptionRepeat)]) return UIViewAnimationOptionAutoreverse;
    NSLog(@"AnimationOption is %@",[self getAnimationOptionDesc]);
    return option.longLongValue;
    
}
-(NSString*)getAnimationOptionDesc{
    NSArray* optionStrArray =
                     @[@"UIViewAnimationOptionLayoutSubviews", //           = 1 <<  0,
                     @"UIViewAnimationOptionAllowUserInteraction", //       = 1 <<  1, // turn on user interaction while animating
                     @"UIViewAnimationOptionBeginFromCurrentState", //      = 1 <<  2, // start all views from current value, not initial value
                     @"UIViewAnimationOptionRepeat", //                = 1 <<  3, // repeat animation indefinitely
                     @"UIViewAnimationOptionAutoreverse", //                = 1 <<  4, // if repeat, run animation back and forth
                     @"UIViewAnimationOptionOverrideInheritedDuration", //  = 1 <<  5, // ignore nested duration
                     @"UIViewAnimationOptionOverrideInheritedCurve", //     = 1 <<  6, // ignore nested curve
                     @"UIViewAnimationOptionAllowAnimatedContent", //       = 1 <<  7, // animate contents (applies to transitions only)
                     @"UIViewAnimationOptionShowHideTransitionViews", //    = 1 <<  8, // flip to/from hidden state instead of adding/removing
                     @"UIViewAnimationOptionOverrideInheritedOptions", //   = 1 <<  9, // do not inherit any options or animation type
                     @"UIViewAnimationOptionCurveEaseInOut", //             = 0 << 16, // default
                     @"UIViewAnimationOptionCurveEaseIn", //              = 1 << 16,
                     @"UIViewAnimationOptionCurveEaseOut", //               = 2 << 16,
                     @"UIViewAnimationOptionCurveLinear", //                = 3 << 16,
                     @"UIViewAnimationOptionTransitionNone", //             = 0 << 20, // default
                     @"UIViewAnimationOptionTransitionFlipFromLeft", //     = 1 << 20,
                     @"UIViewAnimationOptionTransitionFlipFromRight", //    = 2 << 20,
                     @"UIViewAnimationOptionTransitionCurlUp", //           = 3 << 20,
                     @"UIViewAnimationOptionTransitionCurlDown", //         = 4 << 20,
                     @"UIViewAnimationOptionTransitionCrossDissolve", //    = 5 << 20,
                     @"UIViewAnimationOptionTransitionFlipFromTop", //      = 6 << 20,
                     @"UIViewAnimationOptionTransitionFlipFromBottom", //   = 7 << 20,
                     @"UIViewAnimationOptionPreferredFramesPerSecondDefault", //      = 0 << 24,
                     @"UIViewAnimationOptionPreferredFramesPerSecond60", //           = 3 << 24,
                     @"UIViewAnimationOptionPreferredFramesPerSecond30"];
    NSString* optionStr = optionStrArray[AnimationCount];
    return optionStr;
}
-(void)layoutSubviews{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
