//
//  GalleryScrollView.m
//  practice
//
//  Created by 张浩 on 2021/5/9.
//

#import "GalleryScrollView.h"
#import "ImageContentView.h"
@implementation GalleryScrollView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _pageControl = [[UIPageControl alloc]init];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/**
 * 随机颜色
 */
- (UIColor*)randomColor{
    CGFloat hue = (arc4random() %256/256.0);
    CGFloat saturation = (arc4random() %128/256.0) +0.5;
    CGFloat brightness = (arc4random() %128/256.0) +0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}
-(void)setImageArray:(NSArray<UIImage *> *)imageArray{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    for(int i=0;i<imageArray.count;i++)
    {
        ImageContentView *imageView=[[ImageContentView alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
        //再设计imageView看看怎么承载内容
        imageView.backgroundColor = [self randomColor];
        [self addSubview:imageView];
                                   
    }
        CGFloat contW=imageArray.count*width;
        self.contentSize=CGSizeMake(contW, 0);
        self.showsHorizontalScrollIndicator=NO;
        self.pagingEnabled=YES;
        self.pageControl.numberOfPages=imageArray.count;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 0.3 > (int)(0.3 + 0.5) > 0
    // 0.6 > (int)(0.6 + 0.5) > 1
    // 小数四舍五入为整数 ： (int)(小数 + 0.5)
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);    self.pageControl.currentPage=page;
}
@end
