//
//  TestModel.h
//  practice
//
//  Created by 张浩 on 2020/10/25.
//

#import "BaseModel+Practise.h"
NS_ASSUME_NONNULL_BEGIN

@interface TestModel : BaseModel
@property(assign,nonatomic)int age; // 自动生成成员变量，setter和getter的实现，不需要 写@synthesize，但如果在.m文件中使用 @dynamic修饰age则会告诉编译器不会自动生成


-(void)testMethodForwarding;
@end

NS_ASSUME_NONNULL_END
