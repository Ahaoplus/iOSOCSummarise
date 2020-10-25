//
//  BaseModel+Test.m
//  practice
//
//  Created by 张浩 on 2020/10/21.
//

#import "BaseModel+Test.h"

@implementation BaseModel (Test)

+(void)load
{
    NSLog(@"%s",__FUNCTION__);
}
+(void)initialize
{
    NSLog(@"%s",__FUNCTION__);
}
-(void)test{
    NSLog(@"%s",__FUNCTION__);
}
@end
