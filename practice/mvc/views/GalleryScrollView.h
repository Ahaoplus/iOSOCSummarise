//
//  GalleryScrollView.h
//  practice
//
//  Created by 张浩 on 2021/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GalleryScrollView : UIScrollView <UIScrollViewDelegate>
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,strong)NSArray<UIImage*>* imageArray;

@end

NS_ASSUME_NONNULL_END
