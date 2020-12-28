//
//  main.m
//  practice
//
//  Created by 张浩 on 2020/9/22.
//  如果不设置启动页和LaunchScreen  默认是iPhone4的尺寸
//  LaunchScreen.Storyboard  会生成一个截图用于启动页，你放在上面的东西没啥用
//  info.plist 名称发生变化
//  不会自动生成PCH

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

