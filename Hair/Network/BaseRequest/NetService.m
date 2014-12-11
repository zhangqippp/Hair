//
//  XHNetService.m
//  XHNews
//
//  Created by yewei on 14-1-2.
//  Copyright (c) 2014年 yewei. All rights reserved.
//

#import "NetService.h"

@interface NetService()

@property (nonatomic, strong)MKNetworkOperation *networkOperation;

@end

@implementation NetService

- (id)initWithNetworkOperation: (MKNetworkOperation *)networkOperation
{
    if(self = [super init])
    {
        self.networkOperation = networkOperation;
    }
    return self;
}

//取消网络请求
- (void)cancel
{
    [self.networkOperation cancel];
}

//当前网络请求的返回是否是缓存数据
- (BOOL)isCachedResponse
{
    return [self.networkOperation isCachedResponse];
}

@end
