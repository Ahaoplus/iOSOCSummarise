//
//  ZHRequestEngine.m
//  practice
//
//  Created by 张浩 on 2020/11/15.
//

#import "ZHRequestEngine.h"
#import "MBProgressHUD.h"

#import "UIViewController+Find.h"

static NSUInteger timeoutInterval = 30; //网络请求超时时间

static NSString * GET = @"GET";
static NSString * POST = @"POST";

@implementation ZHRequestEngine

+ (AFHTTPSessionManager *)managerShare {
    
    return [AFHTTPSessionManager manager];
}

+ (void)requestByGetTransform:(NSString *)urlPath
               withParameters:(NSDictionary *) parameters
                    withBlock:(BlockResponse) block
                    withErrorBlock:(BlockResponseError) errBlock {
    
    
    [self requestByGetTransform:urlPath withParameters:parameters withBlock:block withErrorBlock:errBlock withNeedHud:YES withNeedCatch:YES];
    
}
+ (void)requestByGetTransform:(NSString *)urlPath
               withParameters:(NSDictionary *) parameters
                    withBlock:(BlockResponse) block
               withErrorBlock:(BlockResponseError) errBlock
                  withNeedHud:(BOOL)needHud
                withNeedCatch:(BOOL)needCatch
          ResponseKeyDisorder:(BOOL)disorder{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //new add
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    [manager.requestSerializer setTimeoutInterval:timeoutInterval];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"multipart/form-data",nil];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"honyfrom"];
    NSString* tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenId"];
    if(tokenID){
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"iPlanetDirectoryPro=%@",tokenID] forHTTPHeaderField:@"Cookie"];
    }
    if (needHud == YES) {
        [MBProgressHUD showHUDAddedTo:[UIViewController find_currentViewController].view animated:YES];
    }

    
    [manager GET:urlPath parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (needHud == YES) {
            [MBProgressHUD hideAllHUDsForView:[UIViewController find_currentViewController].view animated:YES];
        }
        
        if (block != nil) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"code"] intValue]==401) {
                    //跳到登录页面，提示登录已过期
                    
                }else{//做其它处理
                    block(task,responseObject);
                }
                
            }else {
                
                if ([urlPath containsString:@"GetAction"]||[urlPath containsString:@"getAction"]) {
                    
                    block(task,responseObject);
                }else {
                    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    
                    if ([aString containsString:@"\'UserIsAssist\'"]) {
                        aString =  [aString stringByReplacingOccurrencesOfString:@"\'UserIsAssist\'" withString:@"\"UserIsAssist\""];
                        aString = [aString lowercaseString];
                    }
                    
                    NSData *jsonData = [aString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
                    block(task,dic);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (needHud == YES) {
            [MBProgressHUD hideAllHUDsForView:[UIViewController find_currentViewController].view animated:YES];
        }
        
        //        if (needCatch == YES) {
        //            if ([SDJSONDatabase readCatch:parameters andUrl:urlString] == nil) {
        //                if (errBlock != nil) {
        //                    errBlock(task,error);
        //                }
        //            }else {
        //                if (block != nil) {
        //                    [SDJSONDatabase createDatabase];
        //                    block(task,[SDJSONDatabase readCatch:parameters andUrl:urlString]);
        //                }
        //            }
        //        }else {
        if (errBlock != nil) {
            
            errBlock(task,error);
            //            }
        }
    }];
    
}


+ (void)requestByGetTransform:(NSString *)urlPath
               withParameters:(NSDictionary *) parameters
                    withBlock:(BlockResponse) block
               withErrorBlock:(BlockResponseError) errBlock
                  withNeedHud:(BOOL)needHud
                withNeedCatch:(BOOL)needCatch {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //new add
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:timeoutInterval];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"multipart/form-data",nil];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"honyfrom"];
    NSString* tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenId"];
    if(tokenID)
    {
        
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"iPlanetDirectoryPro=%@",tokenID] forHTTPHeaderField:@"Cookie"];
        
    }
    if (needHud == YES) {
        [MBProgressHUD showHUDAddedTo:[UIViewController find_currentViewController].view animated:YES];
    }
    
    [manager GET:urlPath parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (needHud == YES) {
            [MBProgressHUD hideAllHUDsForView:[UIViewController find_currentViewController].view animated:YES];
        }
        
        if (block != nil) {
           
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject isKindOfClass:[NSDictionary class]]&&[[responseObject valueForKey:@"code"] integerValue]==401) {
                    //跳到登录页面，提示登录已过期
                    
                }else{//做其它处理
                    block(task,responseObject);
                }

            }else {
                
                if ([urlPath containsString:@"GetAction"]||[urlPath containsString:@"getAction"]) {
                    
                    block(task,responseObject);
                }else {
                    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    
                    if ([aString containsString:@"\'UserIsAssist\'"]) {
                        aString =  [aString stringByReplacingOccurrencesOfString:@"\'UserIsAssist\'" withString:@"\"UserIsAssist\""];
                        aString = [aString lowercaseString];
                    }
                    
                    NSData *jsonData = [aString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
                    if ([responseObject isKindOfClass:[NSDictionary class]]&&[[responseObject valueForKey:@"code"] integerValue]==401) {
                        //跳到登录页面，提示登录已过期
                       
                        
                    }else{//做其它处理
                        block(task,dic);
                    }
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (needHud == YES) {
            [MBProgressHUD hideAllHUDsForView:[UIViewController find_currentViewController].view animated:YES];
        }
        
        //        if (needCatch == YES) {
        //            if ([SDJSONDatabase readCatch:parameters andUrl:urlString] == nil) {
        //                if (errBlock != nil) {
        //                    errBlock(task,error);
        //                }
        //            }else {
        //                if (block != nil) {
        //                    [SDJSONDatabase createDatabase];
        //                    block(task,[SDJSONDatabase readCatch:parameters andUrl:urlString]);
        //                }
        //            }
        //        }else {
        if (errBlock != nil) {
            
            errBlock(task,error);
            //            }
        }
    }];
}

+(void)requestByPostTransform:(NSString *) urlPath
                withParameters:(NSDictionary *) parameters
                     withBlock:(BlockResponse) block
                withErrorBlock:(BlockResponseError) errBlock
                   withNeedHud:(BOOL)needHud
                 withNeedCatch:(BOOL)needCatch {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"tokenId"])
    {
        NSString* tokenID = @"asdfasdfsadfsadfasdf";//获取token
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"iPlanetDirectoryPro=%@",tokenID] forHTTPHeaderField:@"Cookie"];
        [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"honyfrom"];
    }
    [manager.requestSerializer setTimeoutInterval:timeoutInterval];
    __weak UIViewController* weakCurrentVC = [UIViewController find_currentViewController];
    if (needHud == YES) {
        
        [MBProgressHUD showHUDAddedTo:[UIViewController find_currentViewController].view animated:YES];
    }
    
    [manager POST:urlPath parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (needHud == YES) {
            NSLog(@"MBProgressHUD Hide in %@",NSStringFromClass([weakCurrentVC class]));
            [MBProgressHUD hideAllHUDsForView:weakCurrentVC.view animated:YES];
        }

        if (block != nil) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //4:57
                if ([[responseObject valueForKey:@"code"] integerValue]==401) {
                    //跳到登录页面，提示登录已过期
                }else{//做其它处理
                    block(task,responseObject);
                }

            }else {
                
                if ([urlPath containsString:@"GetAction"] ) {
                    
                    block(task,responseObject);
                }else {
                    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    
                    if ([aString containsString:@"\'UserIsAssist\'"]) {
                       aString =  [aString stringByReplacingOccurrencesOfString:@"\'UserIsAssist\'" withString:@"\"UserIsAssist\""];
                        aString = [aString lowercaseString];
                    }
                    
                    NSData *jsonData = [aString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&err];
                    //4:57
                    if ([[responseObject valueForKey:@"code"] integerValue]==401) {
                        //跳到登录页面，提示登录已过期
                    }else{//做其它处理
                        block(task,dic);
                    }
                    
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (needHud == YES) {
            [MBProgressHUD hideAllHUDsForView:weakCurrentVC.view animated:YES];
        }

        if (errBlock != nil) {
                
            errBlock(task,error);
        }
    }];
}


+ (void)requestByPostTransform:(NSString *) urlPath
                withParameters:(NSDictionary *) parameters
                     withBlock:(BlockResponse) block
                withErrorBlock:(BlockResponseError) errBlock
                    {
    [self requestByPostTransform:urlPath withParameters:parameters withBlock:block withErrorBlock:errBlock withNeedHud:YES withNeedCatch:NO];
}

+ (void) postMultiRequest:(NSString *) urlPath
           withParameters:(NSDictionary *) parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBodyBlock
                withBlock:(BlockResponse) block
           withErrorBlock:(BlockResponseError) errBlock {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",@"http://localhost:8080",urlPath];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [MBProgressHUD showHUDAddedTo:[UIViewController find_currentViewController].view animated:YES];
    
    [manager POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:constructingBodyBlock progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:[UIViewController find_currentViewController].view animated:YES];
        if (block != nil) {
            
            block(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideAllHUDsForView:[UIViewController find_currentViewController].view animated:YES];
        if (errBlock != nil) {
            errBlock(task,error);
        }

    }];
}

+ (void)downloadFile:(NSString *) urlString
           withBlock:(BlockDownload) block
      withErrorBlock:(BlockDownloadError) errBlock {
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                      
                                                                      
                                                                      NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                                                                                            inDomain:NSUserDomainMask
                                                                                                                                   appropriateForURL:nil
                                                                                                                                              create:NO
                                                                                                                                               error:nil];
                                                                      
                                                                      NSLog(@"suggestedFilename: %@", [response suggestedFilename]);
                                                                      
                                                                      return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                      
                                                                  } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                      
                                                                      NSLog(@"File downloaded to: %@", filePath);
                                                                  }];
    
    [downloadTask resume];
    
}

+ (void)uploadFileToServer:(NSString *) urlString
                uploadFile:(NSString *) filePath1
                 withBlock:(BlockUpload) block
            withErrorBlock:(BlockUploadError) errBlock {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSURL *filePath = [NSURL fileURLWithPath:filePath1];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            if (errBlock != nil) {
                
                errBlock(response,responseObject,error);
            }
            
            NSLog(@"Error: %@", error);
        } else {
            
            if (block != nil) {
                
                block(response,responseObject);
            }
            
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}

+ (void)uploadDataToServer:(NSString *) urlString
                uploadFile:(NSString *) filePath1
                 withBlock:(BlockUpload) block
            withErrorBlock:(BlockUploadError) errBlock {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            
            if (errBlock != nil) {
                
                errBlock(response,responseObject,error);
            }
            NSLog(@"Error: %@", error);
        } else {
            
            if (block != nil) {
                
                block(response,responseObject);
            }
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [dataTask resume];
}

@end
