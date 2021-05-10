//
//  ImageShowerSubViewController.h
//  practice
//
//  Created by 张浩 on 2021/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageShowerSubViewController : UIViewController
@property (nonatomic,copy)NSString *tag;
@property (nonatomic,weak)UIViewController* fatherController;
@end

NS_ASSUME_NONNULL_END
