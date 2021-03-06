//
//  TSTextShineView.m
//  TextShine
//
//  Created by Genki on 5/7/14.
//  Copyright (c) 2014 Reteq. All rights reserved.
//

#import "RQShineLabel.h"

@interface RQShineLabel()

@property (strong, nonatomic) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *characterAnimationDurations;
@property (nonatomic, strong) NSMutableArray *characterAnimationDelays;
@property (strong, nonatomic) CADisplayLink *displaylink;
@property (assign, nonatomic) CFTimeInterval beginTime;
@property (assign, nonatomic) CFTimeInterval endTime;
@property (assign, nonatomic, getter = isFadedOut) BOOL fadedOut;
@property (nonatomic, copy) void (^completion)(void);

@end

@implementation RQShineLabel

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }

    [self commonInit];

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    [self commonInit];

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }

    [self commonInit];

    [self setText:self.text];

    return self;
}

- (void)commonInit
{
    // Defaults
    _shineDuration   = 2.5;
    _fadeoutDuration = 2.5;
    _autoStart       = NO;
    _fadedOut        = YES;
    self.textColor  = [UIColor whiteColor];

    _characterAnimationDurations = [NSMutableArray array];
    _characterAnimationDelays    = [NSMutableArray array];

    _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAttributedString)];
    if (@available(iOS 10.0,*)) {
        _displaylink.preferredFramesPerSecond = 4;//间隔多少桢调用一次，默认的是喝屏幕刷新率一致的
    }else{
        _displaylink.frameInterval = 4;
    }
   
   
    _displaylink.paused = YES;
    [_displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];//加入到当前的Runloop
}

- (void)didMoveToWindow
{
    if (nil != self.window && self.autoStart) {
        [self shine];
    }
}

- (void)setText:(NSString *)text
{
    self.attributedText = [[NSAttributedString alloc] initWithString:text];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    self.attributedString = [self initialAttributedStringFromAttributedString:attributedText];
    [super setAttributedText:self.attributedString];
    for (NSUInteger i = 0; i < attributedText.length; i++) {
        //arc4random()是一个真正的伪随机算法，不需要随机数种子。产生一个[0,100)的数字
        //使用arc4random()产生指定的随机数还需要做取模运算，而arc4random_uniform()则不需要，看下面函数定义，传入一个上边界数字
        self.characterAnimationDelays[i] = @(arc4random_uniform(self.shineDuration / 2 * 100) / 100.0);//每个字母动画延迟时间
        CGFloat remain = self.shineDuration - [self.characterAnimationDelays[i] floatValue];//每个字母动画的剩余时间
        self.characterAnimationDurations[i] = @(arc4random_uniform(remain * 100) / 100.0);
    }
}

- (void)shine
{
    [self shineAnimated:YES completion:NULL];
}

- (void)shineAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.isFadedOut) {
        if (animated) {
            if (!self.isShining) {
                self.completion = completion;
                self.fadedOut = NO;
                [self startAnimationWithDuration:self.shineDuration];
            }

        } else {
            self.fadedOut = NO;
            self.displaylink.paused = YES;
            
            UIColor *color = [self.textColor colorWithAlphaComponent:1];
            [self.attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.attributedString.string.length)];
            [super setAttributedText:self.attributedString];
            if (completion) {
                completion();
            }
        }
    }
}

- (void)fadeOut
{
    [self fadeOutAnimated:YES completion:NULL];
}

- (void)fadeOutAnimated:(BOOL)animated completion:(void (^)(void))completion {

    if (!self.isFadedOut) {
        if (animated) {
            if (!self.isShining) {
                self.completion = completion;
                self.fadedOut = YES;
                [self startAnimationWithDuration:self.fadeoutDuration];
            }

        } else {
            self.fadedOut = YES;
            self.displaylink.paused = YES;

            UIColor *color = [self.textColor colorWithAlphaComponent:0];
            [self.attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.attributedString.string.length)];
            [super setAttributedText:self.attributedString];
            if (completion) {
                completion();
            }
        }
    }
}

- (BOOL)isShining
{
    return !self.displaylink.isPaused;
}

- (BOOL)isVisible
{
    return NO == self.isFadedOut;
}


#pragma mark - Private methods

- (void)startAnimationWithDuration:(CFTimeInterval)duration
{
    self.beginTime = CACurrentMediaTime();
    self.endTime = self.beginTime + duration;
    self.displaylink.paused = NO;
}

- (void)updateAttributedString
{//CADisplayLink指向的方法，一直绘制
    CFTimeInterval now = CACurrentMediaTime();
    for (NSUInteger i = 0; i < self.attributedString.length; i ++) {
        //判断这个字符是否为空格，是的话不需要处理
        if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self.attributedString.string characterAtIndex:i]]) {
            continue;
        }
        [self.attributedString enumerateAttribute:NSForegroundColorAttributeName
                                          inRange:NSMakeRange(i, 1)
                                          options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                       usingBlock:^(id value, NSRange range, BOOL *stop) {

            CGFloat currentAlpha = CGColorGetAlpha([(UIColor *)value CGColor]);
            //渐进
            BOOL shouldUpdateAlpha = (self.isFadedOut && currentAlpha > 0) || (!self.isFadedOut && currentAlpha < 1) || (now - self.beginTime) >= [self.characterAnimationDelays[i] floatValue];

            if (!shouldUpdateAlpha) {
                return;
            }
            //更新某个字母的透明度
            CGFloat percentage = (now - self.beginTime - [self.characterAnimationDelays[i] floatValue]) / ( [self.characterAnimationDurations[i] floatValue]);
            if (self.isFadedOut) {
                percentage = 1 - percentage;
            }
            //对每个字母进行变色操作
            UIColor *color = [self.textColor colorWithAlphaComponent:percentage];
            [self.attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
        }];
    }
    [super setAttributedText:self.attributedString];
    //结束动画重设各个字母的动画时间
    if (now > self.endTime) {
        self.displaylink.paused = YES;

        for (NSUInteger i = 0; i < self.attributedString.length; i++) {
            self.characterAnimationDelays[i] = @(arc4random_uniform(self.fadeoutDuration / 2 * 100) / 100.0);
            CGFloat remain = self.fadeoutDuration - [self.characterAnimationDelays[i] floatValue];
            self.characterAnimationDurations[i] = @(arc4random_uniform(remain * 100) / 100.0);
        }


        if (self.completion) {
            self.completion();
        }
    }
}

- (NSMutableAttributedString *)initialAttributedStringFromAttributedString:(NSAttributedString *)attributedString
{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    UIColor *color = [self.textColor colorWithAlphaComponent:0];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, mutableAttributedString.length)];
    return mutableAttributedString;
}


@end
