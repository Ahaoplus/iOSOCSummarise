//
//  ImageShowerSubViewController.m
//  practice
//
//  Created by 张浩 on 2021/5/9.
//

#import "ImageShowerSubViewController.h"
#import "GalleryScrollView.h"
@interface ImageShowerSubViewController ()

@end

@implementation ImageShowerSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    GalleryScrollView* galleryView = [[GalleryScrollView alloc] initWithFrame:self.view.bounds];//画廊
    UIImage* image1 = [UIImage imageNamed:@"蜘蛛侠落地"];
    UIImage* image2 = [UIImage imageNamed:@"zhufu"];
    UIImage* image3 = [UIImage imageNamed:@"taiji"];
    galleryView.imageArray = @[image1,image2,image3];
    [self.view addSubview:galleryView];
}
-(void)jumpToPage:(UIViewController*)vc{
    if (self.navigationController) {
      [self.navigationController pushViewController:vc animated:YES];
    }else{
      [self.fatherController.navigationController pushViewController:vc animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
