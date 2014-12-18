//
//  XHNetService.h
//  XHNews
//
//  Created by yewei on 14-1-2.
//  Copyright (c) 2014年 yewei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetService : NSObject

- (id)initWithNetworkOperation: (MKNetworkOperation *)networkOperation;


#pragma mark -
#pragma mark - 对外接口

//取消网络请求
- (void)cancel;

//当前网络请求的返回是否是缓存数据
- (BOOL)isCachedResponse;

@end
