//
//  ZHOOViewController.h
//  practice
//
//  Created by 张浩 on 2020/10/8.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHOOViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(readonly)NSString* pageDescription;
@end

NS_ASSUME_NONNULL_END
