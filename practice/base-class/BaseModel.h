//
//  BaseModel.h
//  practice
//
//  Created by 张浩 on 2020/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)BaseModel* singleChild;

-(void)testCopy;
@end

NS_ASSUME_NONNULL_END
