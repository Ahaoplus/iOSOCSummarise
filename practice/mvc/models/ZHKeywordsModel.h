//
//  ZHKeywordsModel.h
//  practice
//
//  Created by 张浩 on 2020/10/7.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHKeywordsModel : BaseModel

@property(nonatomic,copy)NSString* strCopy;
@property(nonatomic,strong,nullable)NSMutableString* strStrong;
@property(nonatomic,assign)NSString* strAssgin;
@property(nonatomic,weak)NSString* strWeak;

@end

NS_ASSUME_NONNULL_END
