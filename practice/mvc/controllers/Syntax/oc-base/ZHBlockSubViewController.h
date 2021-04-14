//
//  ZHBlockSubViewController.h
//  practice
//
//  Created by 张浩 on 2020/12/28.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHBlockSubViewController : BaseViewController
@property(nonatomic,copy) void(^testVCVCBlock)(void);
@end

NS_ASSUME_NONNULL_END
