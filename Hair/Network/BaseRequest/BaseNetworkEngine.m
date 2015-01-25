//
//  BaseNetworkEngine.m
//  News
//
//  Created by yewei on 14-1-2.
//  Copyright (c) 2014年 yewei. All rights reserved.
//

#import "BaseNetworkEngine.h"
#import "T8KeychainHelper.h"

@implementation BaseNetworkEngine

+ (BaseNetworkEngine *)sharedInstance
{
    static BaseNetworkEngine *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[BaseNetworkEngine alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if(self = [super initWithHostName:kAppBaseURL])
    {
        [self useCache];
    }
    return self;
}


#pragma mark -
#pragma mark - 对外发送网络请求的接口
//调用该方法发送普通的get网络请求, 默认禁止缓存
-(NetService *)sendRequestUrlPath:(NSString *)strUrlPath
                         dictParams:(NSDictionary *)dictParams
                       successBlock:(YQRequestSuccess)successBlock
                       failureBlock:(YQRequestFailuer)failureBlock
{
    return [self sendRequestUrlPath:strUrlPath dictParams:dictParams useCahceResponse:NO successBlock:successBlock failureBlock:failureBlock];
}

//同上，但是带有是否缓存的参数
- (NetService *)sendRequestUrlPath:(NSString *)strUrlPath
                          dictParams:(NSDictionary *)dictParams
                    useCahceResponse:(BOOL)bUseCahceResponse
                        successBlock:(YQRequestSuccess)successBlock
                        failureBlock:(YQRequestFailuer)failureBlock
{
    NSString *urlString = [self absoluteUrlString:strUrlPath];
    return[self sendRequestRemoteUrl:urlString
                          dictParams:dictParams
                    useCahceResponse:bUseCahceResponse
                        successBlock:successBlock
                        failureBlock:failureBlock];
    
}

- (NetService *)sendRequestRemoteUrl:(NSString *)remoteURL
                            dictParams:(NSDictionary *)dictParams
                      useCahceResponse:(BOOL)bUseCahceResponse
                          successBlock:(YQRequestSuccess)successBlock
                          failureBlock:(YQRequestFailuer)failureBlock
{
    MKNetworkOperation *networkOperation = [self operationWithURLString:remoteURL params:dictParams httpMethod:@"GET"];

    [networkOperation addHeaders:[self getHttpHeaderParams]];

    if(!bUseCahceResponse)  //不使用缓存策略
    {
        networkOperation.shouldNotCacheResponse = YES;
    }
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation){

        NSMutableDictionary *mutDictRet = [NSMutableDictionary dictionaryWithDictionary:[completedOperation responseJSON]];

        if (mutDictRet == nil || mutDictRet == NULL || [mutDictRet isEqual:[NSNull null]]) {
//            [MessageHelper showMessage:@"数据错误！"];
        }else{
            successBlock(mutDictRet);
        }
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* error){
        failureBlock(error);
    }];
    
    [self enqueueOperation:networkOperation];
    
    NetService *netService = [[NetService alloc] initWithNetworkOperation:networkOperation];
    return netService;
}

- (NetService*)postRequestUrlPath:(NSString *)strUrlPath
                         dictParams:(NSDictionary *)dictParams
                       successBlock:(YQRequestSuccess)successBlock
                       failureBlock:(YQRequestFailuer)failureBlock
{
    
    NSString *urlString = [self absoluteUrlString:strUrlPath];
    return [self postRequestRemoteUrl:urlString dictParams:dictParams successBlock:successBlock failureBlock:failureBlock];
}

- (NetService *)postRequestRemoteUrl:(NSString *)remoteURL
                            dictParams:(NSDictionary *)dictParams
                          successBlock:(YQRequestSuccess)successBlock
                          failureBlock:(YQRequestFailuer)failureBlock
{
    MKNetworkOperation *networkOperation = [self operationWithURLString:remoteURL params:dictParams httpMethod:@"POST"];
    [networkOperation addHeaders:[self getHttpHeaderParams]];
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation){
        NSMutableDictionary *mutDictRet = [NSMutableDictionary dictionaryWithDictionary:[completedOperation responseJSON]];
        if (mutDictRet == nil || mutDictRet == NULL || [mutDictRet isEqual:[NSNull null]]) {
            [YQMessageHelper showMessage:@"数据错误！"];
        }else{
           successBlock(mutDictRet);
        }
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* error){
        failureBlock(error);
    }];
    
    [self enqueueOperation:networkOperation];
    
    NetService *netService = [[NetService alloc] initWithNetworkOperation:networkOperation];
    return netService;
}

//调用该方法依据文件名上传本地文件, 具体说明见头文件
-(NetService *)uploadFilefromPath:(NSString *)strFilePath
                       strRemoteURL:(NSString *)strRemoteURL
                         dictParams:(NSDictionary *)dictParams
                       successBlock:(YQRequestSuccess)successBlock
                       failureBlock:(YQRequestFailuer)failureBlock;
{
    
    NSString *fileName = [strFilePath lastPathComponent];
    NSData *fileData = [NSData dataWithContentsOfFile:strFilePath];
    
    return [self uploadFile:fileData fileName:fileName strRemoteURL:strRemoteURL dictParams:dictParams successBlock:successBlock failureBlock:failureBlock ];
}

//调用该方法依据文件名上传本地文件, strUrlPath传送的除根url以外的urlPath, 若要传完整的url, 请调用上面的方法
- (NetService *)uploadFilefromPath:(NSString *)strFilePath
                          strUrlPath:(NSString *)strUrlPath
                          dictParams:(NSDictionary *)dictParams
                        successBlock:(YQRequestSuccess)successBlock
                        failureBlock:(YQRequestFailuer)failureBlock
{
    NSString *remoteUrl = [self absoluteUrlString:strUrlPath];
    return [self uploadFilefromPath:strFilePath strRemoteURL:remoteUrl dictParams:dictParams successBlock:successBlock failureBlock:failureBlock];
}

- (NetService *)uploadFilefromPath:(NSString *)strFilePath forKey:(NSString *)key strUrlPath:(NSString *)strUrlPath dictParams:(NSDictionary *)dictParams successBlock:(YQRequestSuccess)successBlock failureBlock:(YQRequestFailuer)failureBlock
{
    NSString *remoteUrl = [self absoluteUrlString:strUrlPath];
    MKNetworkOperation *networkOperation = [self operationWithURLString:remoteUrl
                                                                 params:dictParams
                                                             httpMethod:@"POST" timeOutInSeconds:kMKNetworkKitRequestTimeOutInSeconds];
    [networkOperation addHeaders:[self getHttpHeaderParams]];
    
    //添加文件
    NSData *fileData = [NSData dataWithContentsOfFile:strFilePath];
    NSString *strFileName = [strFilePath lastPathComponent];
    [networkOperation addData:fileData forKey:key fileName:strFileName];
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation){
        
        NSMutableDictionary *mutDictRet = [NSMutableDictionary dictionaryWithDictionary:[completedOperation responseJSON]];
        [mutDictRet setObject:[completedOperation yqNetworkIdString] forKey:KYQNetworkIdString];
        
        successBlock(mutDictRet);
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* error){
        
        failureBlock(error);
    }];
    
    [self enqueueOperation:networkOperation];
    
    NetService *netService = [[NetService alloc] initWithNetworkOperation:networkOperation];
    return netService;
}

//调用该方法，直接上传文件数据, urlPath为后台接口的部分路径
- (NetService *)uploadFile:(NSData *)fileData
                    fileName:(NSString *)strFileName
                  strUrlPath:(NSString *)strUrlPath
                  dictParams:(NSDictionary *)dictParams
                successBlock:(YQRequestSuccess)successBlock
                failureBlock:(YQRequestFailuer)failureBlock
{
    NSString *remoteUrl = [self absoluteUrlString:strUrlPath];
    return [self uploadFile:fileData fileName:strFileName strRemoteURL:remoteUrl dictParams:dictParams successBlock:successBlock failureBlock:failureBlock ];
}

//增加超时时间
- (NetService *)uploadFile:(NSData *)fileData
                    fileName:(NSString *)strFileName
                  strUrlPath:(NSString *)strUrlPath
                  dictParams:(NSDictionary *)dictParams
                successBlock:(YQRequestSuccess)successBlock
                failureBlock:(YQRequestFailuer)failureBlock
            timeOutInSeconds:(NSTimeInterval)timeOutInSeconds
{
    NSString *remoteUrl = [self absoluteUrlString:strUrlPath];
    return [self uploadFile:fileData fileName:strFileName strRemoteURL:remoteUrl dictParams:dictParams successBlock:successBlock failureBlock:failureBlock timeOutInSeconds:timeOutInSeconds];
}

-(NetService *)uploadFile:(NSData *)fileData
                   fileName:(NSString *)strFileName
               strRemoteURL:(NSString *)strRemoteURL
                 dictParams:(NSDictionary *)dictParams
               successBlock:(YQRequestSuccess)successBlock
               failureBlock:(YQRequestFailuer)failureBlock
{
    return [self uploadFile:fileData fileName:strFileName strRemoteURL:strRemoteURL dictParams:dictParams successBlock:successBlock failureBlock:failureBlock timeOutInSeconds:kMKNetworkKitRequestTimeOutInSeconds];
}

//调用该方法上传本地文件数据， fileData表示要上传的文件, fileName表示要上传的文件名(不包含路径)，strRemoteUrl为后台接口的绝对路径
-(NetService *)uploadFile:(NSData *)fileData
                   fileName:(NSString *)strFileName
               strRemoteURL:(NSString *)strRemoteURL
                 dictParams:(NSDictionary *)dictParams
               successBlock:(YQRequestSuccess)successBlock
               failureBlock:(YQRequestFailuer)failureBlock
           timeOutInSeconds:(NSTimeInterval)timeOutInSeconds
{
    MKNetworkOperation *networkOperation = [self operationWithURLString:strRemoteURL
                                                                 params:dictParams
                                                             httpMethod:@"POST" timeOutInSeconds:timeOutInSeconds];
    [networkOperation addHeaders:[self getHttpHeaderParams]];
    
    //添加文件
    [networkOperation addData:fileData forKey:@"data" fileName:strFileName];
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation){
        
        NSMutableDictionary *mutDictRet = [NSMutableDictionary dictionaryWithDictionary:[completedOperation responseJSON]];
        [mutDictRet setObject:[completedOperation yqNetworkIdString] forKey:KYQNetworkIdString];
        
        successBlock(mutDictRet);
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* error){
        
        failureBlock(error);
    }];
    
    [self enqueueOperation:networkOperation];
    
    NetService *netService = [[NetService alloc] initWithNetworkOperation:networkOperation];
    return netService;
}

//调用该方法从远程服务器上下载文件，并保存到本地指定路径
-(NetService *)downloadFileFrom:(NSString *)strRemoteURL
                           toFile:(NSString *)strDesFilePath
                     successBlock:(YQRequestSuccess)successBlock
                     failureBlock:(YQRequestFailuer)failureBlock;
{
    MKNetworkOperation *networkOperation = [self operationWithURLString:strRemoteURL];
    [networkOperation addHeaders:[self getHttpHeaderParams]];
    
    if(strDesFilePath.length > 0)
    {
        [networkOperation addDownloadStream:[NSOutputStream outputStreamToFileAtPath:strDesFilePath
                                                                              append:YES]];
    }
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation){
        
        NSMutableDictionary *mutDictRet = [NSMutableDictionary dictionaryWithDictionary:[completedOperation responseJSON]];
        [mutDictRet setObject:[completedOperation yqNetworkIdString] forKey:KYQNetworkIdString];
        
        successBlock(mutDictRet);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* error){
        
        failureBlock(error);
    }];
    
    
    [self enqueueOperation:networkOperation];
    
    NetService *netService = [[NetService alloc] initWithNetworkOperation:networkOperation];
    return netService;
}

- (NetService *)imageAtRemoteURl:(NSString *)strRemoteURL
                      successBlock:(YQImageBlock) imageFetchedBlock
                      failureBlock:(YQRequestFailuer) failureBlock
                     progressBlock:(YQNetProgress)progressBlock
{
    NSURL *url = [NSURL URLWithString:strRemoteURL];
    MKNetworkOperation *networkOperation = [self imageAtURL:url completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        imageFetchedBlock(fetchedImage, url, isInCache);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        failureBlock(error);
    }];
    
    if(progressBlock != nil)
    {
        [networkOperation onDownloadProgressChanged:^(double progress) {
            progressBlock(progress);
        }];
    }
    
    NetService *netService = [[NetService alloc] initWithNetworkOperation:networkOperation];
    return netService;
}

- (NetService *)downLoadData:(NSString *)strRemoteURL
                originRetBlock:(YQOriginRetBlock)originRetBlock
                       failure:(YQRequestFailuer) failureBlock
                 progressBlock:(YQNetProgress)progressBlock
{
    //容错处理
    if(strRemoteURL.length < 4)
    {
        return nil;
    }
    
    MKNetworkOperation *networkOperation = [self operationWithURLString:strRemoteURL];
    networkOperation.shouldCacheResponseEvenIfProtocolIsHTTPS = YES;
    [networkOperation addHeaders:[self getHttpHeaderParams]];
    
    if(progressBlock != nil)
    {
        [networkOperation onDownloadProgressChanged:^(double progress) {
            progressBlock(progress);
        }];
    }
    
    [networkOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        if (originRetBlock)
            originRetBlock([completedOperation responseData],
                           [completedOperation isCachedResponse]);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    //jie.wang 如果该operation支持缓存，且本地存在该operation缓存的图片，则直接返回，不再进行网络请求。
    if([networkOperation isCacheable])
    {
        NSData *cachedData = [self cachedDataForOperation:networkOperation];
        UIImage *imgTmp = [UIImage imageWithData:cachedData];
        if(cachedData && (imgTmp.size.width != 0 && imgTmp.size.height != 0))
        {
            originRetBlock(cachedData, YES);
            return nil;
        }
    }
    
    [self enqueueOperation:networkOperation];
    
    NetService *netService = [[NetService alloc] initWithNetworkOperation:networkOperation];
    return netService;
}

#pragma mark -
#pragma mark - Private Methods
- (NSString *)absoluteUrlString:(NSString *)relativeUrlPath
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://%@", self.readonlyHostName];
    
    if(self.portNumber != 0)
        [urlString appendFormat:@":%d", self.portNumber];
    
    if(self.apiPath)
        [urlString appendFormat:@"/%@", self.apiPath];
    
    if(![relativeUrlPath isEqualToString:@"/"]) { // fetch for root?
        
        if(relativeUrlPath.length > 0 && [relativeUrlPath characterAtIndex:0] == '/') // if user passes /, don't prefix a slash
            [urlString appendFormat:@"%@", relativeUrlPath];
        else if (relativeUrlPath != nil)
            [urlString appendFormat:@"/%@", relativeUrlPath];
    }
    return urlString;
}

- (NSDictionary *)getHttpHeaderParams
{
    NSMutableDictionary *mutDictHeaderParams = [NSMutableDictionary dictionary];

    [mutDictHeaderParams setObject:@"iphone" forKey:@"UserAgent"];
    [mutDictHeaderParams setObject:@"appstore" forKey:@"channelId"];
    [mutDictHeaderParams setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"productId"];
    [mutDictHeaderParams setObject:[T8KeychainHelper UDID] forKey:@"uniqueId"];
    
    NSLog(@"%@",mutDictHeaderParams);
    
    return mutDictHeaderParams;
}

@end
