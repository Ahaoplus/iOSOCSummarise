//  Desc : 对AFN封装一层好在业务层使用
//  ZHRequestEngine.h
//  practice
//
//  Created by 张浩 on 2020/11/15.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHRequestEngine : NSObject

typedef void (^BlockResponse)(NSURLSessionDataTask *task, id responseObject);
typedef void (^BlockResponseError)(NSURLSessionDataTask *task, NSError *error);
typedef void (^BlockDownload)(NSURL *targetPath, NSURLResponse *response);
typedef void (^BlockDownloadError)(NSURLResponse *response, NSURL *filePath, NSError *error);
typedef void (^BlockUpload)(NSURLResponse *response, id responseObject);
typedef void (^BlockUploadError)(NSURLResponse *response, id responseObject, NSError *error);
typedef void(^successBlock)(id success);
typedef void(^failureBlock)(id failure);

+ (AFHTTPSessionManager *)managerShare;

+ (void) requestByGetTransform:(NSString *)urlPath
               withParameters:(NSDictionary *) parameters
                    withBlock:(BlockResponse) block
               withErrorBlock:(BlockResponseError) errBlock
                   withNeedHud:(BOOL)needHud
                 withNeedCatch:(BOOL)needCatch;

+ (void)requestByGetTransform:(NSString *)urlPath
               withParameters:(NSDictionary *) parameters
                    withBlock:(BlockResponse) block
               withErrorBlock:(BlockResponseError) errBlock;

+ (void) requestByPostTransform:(NSString *) urlPath
                withParameters:(NSDictionary *) parameters
                     withBlock:(BlockResponse) block
                withErrorBlock:(BlockResponseError) errBlock;

+ (void)requestByPostTransform:(NSString *) urlPath
                withParameters:(NSDictionary *) parameters
                     withBlock:(BlockResponse) block
                withErrorBlock:(BlockResponseError) errBlock
                   withNeedHud:(BOOL)needHud
                 withNeedCatch:(BOOL)needCatch;

+ (void) downloadFile:(NSString *) urlString
           withBlock:(BlockDownload) block
      withErrorBlock:(BlockDownloadError) errBlock;

+ (void) uploadFileToServer:(NSString *) urlString
                uploadFile:(NSString *) filePath1
                 withBlock:(BlockUpload) block
            withErrorBlock:(BlockUploadError) errBlock;

+ (void) uploadDataToServer:(NSString *) urlString
                uploadFile:(NSString *) filePath1
                 withBlock:(BlockUpload) block
            withErrorBlock:(BlockUploadError) errBlock;

+ (void) postMultiRequest:(NSString *) urlPath
           withParameters:(NSDictionary *) parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBodyBlock
                withBlock:(BlockResponse) block
           withErrorBlock:(BlockResponseError) errBlock;

+ (void)requestByGetTransform:(NSString *)urlPath
               withParameters:(NSDictionary *) parameters
                    withBlock:(BlockResponse) block
               withErrorBlock:(BlockResponseError) errBlock
                  withNeedHud:(BOOL)needHud
                withNeedCatch:(BOOL)needCatch
          ResponseKeyDisorder:(BOOL)disorder;

@end

NS_ASSUME_NONNULL_END
