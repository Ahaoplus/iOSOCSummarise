//
//  ZHGPUViewController.m
//  practice
//
//  Created by 张浩 on 2020/12/28.
//

#import "ZHGPUViewController.h"

@interface ZHGPUViewController ()

@end

@implementation ZHGPUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.knowledgeWebSource = @"https://juejin.cn/post/6847902222567604231";
    self.knowledgePoints = @"1、屏幕渲染（On-Screen Rendering）：正常情况下，我们在屏幕上显示都是GPU读取帧缓冲区（Frame Buffer）渲染好的的数据，然后显示在屏幕上。\n\
    2、离屏渲染：Off-Screen Rendering：如果有时因为一些限制，无法把渲染结果直接写入frame buffer，而是先暂存在另外的内存区域，之后再写入frame buffer，那么这个过程被称之为离屏渲染。也就是GPU需要在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。\n\
    对于每一层的layer要么能够通过单次遍历就能完成渲染，要么就只能令开辟一块内存作为临时中转区来完成复杂的修改/裁剪等操作。\n \
    只是控件设置了圆角或（圆角+裁剪）并不会触发离屏渲染，同时需要满足父layer需要裁剪时，子layer也因为父layer设置了圆角也需要被裁剪（即视图contents有内容并发生了多图层被裁剪）时才会触发离屏渲染。\n 其他会触发离屏渲染的场景:\n采用了光栅化的 layer (layer.shouldRasterize)\n使用了 mask 的 layer (layer.mask)\n需要进行裁剪的 layer (layer.masksToBounds /view.clipsToBounds)\n设置了组透明度为 YES，并且透明度不为 1 的layer (layer.allowsGroupOpacity/ layer.opacity)\n使用了高斯模糊添加了投影的 layer (layer.shadow*)\n绘制了文字的 layer (UILabel, CATextLayer, Core Text 等)\n\n\劣势离屏渲染增大了系统的负担，会形象App性能。主要表现在以下几个方面：\n\离屏渲染需要额外的存储空间，渲染空间大小的上限是2.5倍的屏幕像素大小，超过无法使用离屏渲染\n\容易掉帧：一旦因为离屏渲染导致最终存入帧缓存区的时候，已经超过了16.67ms，则会出现掉帧的情况，造成卡顿\n\优势\n\虽然离屏渲染会需要多开辟出新的临时缓存区来存储中间状态，但是对于多次出现在屏幕上的数据，可以提前渲染好，从而进行复用，这样CPU/GPU就不用做一些重复的计算。\n\特殊产品需求，为实现一些特殊动效果，需要多图层以及离屏缓存区保存中间状态，这种情况下就不得不使用离屏渲染。比如产品需要实现高斯模糊，无论自定义高斯模糊还是调用系统API都会触发离屏渲染。";
    
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
