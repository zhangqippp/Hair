//
//  BaseNetworkEngine.h
//  News
//
//  Created by yewei on 14-1-2.
//  Copyright (c) 2014年 yewei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkOperation.h"
#import "MKNetworkEngine.h"
#import "NetService.h"

//测试环境
#define kAppBaseURL  @"api.hair.feedss.com"

typedef void (^YQRequestSuccess)(NSDictionary *dictRet);        //成功的回调,dictRet代表网络返回结果
typedef void (^YQRequestFailuer)(NSError *error);               //失败的回调,error代表网络访问失败的错误对象
typedef void (^YQNetProgress)(double dProg);                    //网络进度的指示， dProg的取值在0~1
typedef void (^YQImageBlock) (UIImage* fetchedImage, NSURL* url, BOOL isInCache);
typedef void (^YQOriginRetBlock)(NSData *originData, BOOL isInCache);  //获取服务器原始数据


@interface BaseNetworkEngine : MKNetworkEngine

+ (BaseNetworkEngine *)sharedInstance;

/*
 *****************   参数若为remoteUrl，代表你请求的url为完整的url        ********************
 *****************   参数若为urlPath,代表你请求的url为除去根url外的部分    ********************
 */

/*
 @abstract 调用该方法发送普通的get请求, 默认不采用缓存策略
 
 @params:
 strUrlPath:   除去根url以外的url部分, 例如，登陆请求只用传“login"
 dictParams:   参数词典，例如，登陆请求传{userName: xxxx,   password: xxxx}
 successBlock: 网络请求成功时的回调方法
 failuerBlock: 网络请求失败时的回调方法
 
 @return:
 NetService, 本次网络请求对应的对象， 提供了诸如，取消网络请求cancel等, 具体参见NetService头文件
 */
-(NetService *)sendRequestUrlPath:(NSString *)strUrlPath
                         dictParams:(NSDictionary *)dictParams
                       successBlock:(YQRequestSuccess)successBlock
                       failureBlock:(YQRequestFailuer)failureBlock;


/*
 @abstract 方法定义同发送普通get请求，增加参数useCacheResponse表示是否使用缓存数据
 */
-(NetService *)sendRequestUrlPath:(NSString *)strUrlPath
                         dictParams:(NSDictionary *)dictParams
                   useCahceResponse:(BOOL)bUseCahceResponse
                       successBlock:(YQRequestSuccess)successBlock
                       failureBlock:(YQRequestFailuer)failureBlock;

/*
 @abstract 向服务器发送普通post请求，其他参数同发送普通的get请求
 */
- (NetService *)postRequestUrlPath:(NSString *)strUrlPath
                          dictParams:(NSDictionary *)dictParams
                        successBlock:(YQRequestSuccess)successBlock
                        failureBlock:(YQRequestFailuer)failureBlock;

/*
 @abstract 向服务器发送get请求, remoteURl表示完整的url地址， 其它参数同普通get请求
 */
- (NetService *)sendRequestRemoteUrl:(NSString *)remoteURL
                            dictParams:(NSDictionary *)dictParams
                      useCahceResponse:(BOOL)bUseCahceResponse
                          successBlock:(YQRequestSuccess)successBlock
                          failureBlock:(YQRequestFailuer)failureBlock;

/*
 @abstract 向服务器发送post请求，remoteURL表示完整的url地址, 其它参数同普通get请求
 */
- (NetService *)postRequestRemoteUrl:(NSString *)remoteURL
                            dictParams:(NSDictionary *)dictParams
                          successBlock:(YQRequestSuccess)successBlock
                          failureBlock:(YQRequestFailuer)failureBlock;


/*
 @abstract 调用该方法依据文件名上传本地文件
 
 @parmas:
 strFilePath:    待上传文件的本地绝对路径
 bNeedFreezable: 是否冻结网络请求(如果该属性设置为YES, 则该请求因网络中断失败后，待下次有网时会自动发出)
 strRemoteURL:   完整目的地址
 dictParams, successBlock, failureBlock 与发送普通的get网络请求参数含义相同
 
 @return:
 返回值同发送普通的网络请求
 */
-(NetService *)uploadFilefromPath:(NSString *)strFilePath
                       strRemoteURL:(NSString *)strRemoteURL
                         dictParams:(NSDictionary *)dictParams
                       successBlock:(YQRequestSuccess)successBlock
                       failureBlock:(YQRequestFailuer)failureBlock;

/*
 @abstract
 调用该方法依据文件名上传本地文件, strUrlPath传送的除根url以外的urlPath, 若要传完整的url, 请调用strRemoteURL的方法
 */
- (NetService *)uploadFilefromPath:(NSString *)strFilePath
                          strUrlPath:(NSString *)strUrlPath
                          dictParams:(NSDictionary *)dictParams
                        successBlock:(YQRequestSuccess)successBlock
                        failureBlock:(YQRequestFailuer)failureBlock;

/**
 *  调用该方法依据文件名上传本地文件
 *
 *  @param strFilePath  本地文件路径
 *  @param key          key
 *  @param strUrlPath   远程地址
 *  @param dictParams   参数
 *  @param successBlock
 *  @param failureBlock
 *
 *  @return 
 */
- (NetService *)uploadFilefromPath:(NSString *)strFilePath
                            forKey:(NSString *)key
                        strUrlPath:(NSString *)strUrlPath
                        dictParams:(NSDictionary *)dictParams
                      successBlock:(YQRequestSuccess)successBlock
                      failureBlock:(YQRequestFailuer)failureBlock;

/*
 @abstract
 调用该方法上传本地文件数据， strUrlPath是除了根url以外的部分, 若需要穿完整地址，请调用strRemoteURL的方法
 */
- (NetService *)uploadFile:(NSData *)fileData
                    fileName:(NSString *)strFileName
                  strUrlPath:(NSString *)strUrlPath
                  dictParams:(NSDictionary *)dictParams
                successBlock:(YQRequestSuccess)successBlock
                failureBlock:(YQRequestFailuer)failureBlock;

- (NetService *)uploadFile:(NSData *)fileData
                    fileName:(NSString *)strFileName
                  strUrlPath:(NSString *)strUrlPath
                  dictParams:(NSDictionary *)dictParams
                successBlock:(YQRequestSuccess)successBlock
                failureBlock:(YQRequestFailuer)failureBlock
            timeOutInSeconds:(NSTimeInterval)timeOutInSeconds;


/*
 @abastract
 调用该方法上传本地文件数据， fileData表示要上传的文件, fileName表示要上传的文件名(不包含路径)，其它参数同上
 */
-(NetService *)uploadFile:(NSData *)fileData
                   fileName:(NSString *)strFileName
               strRemoteURL:(NSString *)strRemoteURL
                 dictParams:(NSDictionary *)dictParams
               successBlock:(YQRequestSuccess)successBlock
               failureBlock:(YQRequestFailuer)failureBlock;

/*
 @abstract
 添加超时时间
 */
-(NetService *)uploadFile:(NSData *)fileData
                   fileName:(NSString *)strFileName
               strRemoteURL:(NSString *)strRemoteURL
                 dictParams:(NSDictionary *)dictParams
               successBlock:(YQRequestSuccess)successBlock
               failureBlock:(YQRequestFailuer)failureBlock
           timeOutInSeconds:(NSTimeInterval)timeOutInSeconds;




/*
 @abstract 调用该方法从远程服务器上下载文件，并保存到本地指定路径
 
 @parmas:
 remoteURL: 待下载文件的完整url
 desFilePath: 下载文件成功后本地保存的地址
 
 @return:
 返回值同发送普通的网络请求
 */

-(NetService *)downloadFileFrom:(NSString *)strRemoteURL
                           toFile:(NSString *)strDesFilePath
                     successBlock:(YQRequestSuccess)successBlock
                     failureBlock:(YQRequestFailuer)failureBlock;

/*
 下载图片的请求
 */
- (NetService *)imageAtRemoteURl:(NSString *)strRemoteURL
                      successBlock:(YQImageBlock) imageFetchedBlock
                      failureBlock:(YQRequestFailuer) errorBlock
                     progressBlock:(YQNetProgress)progressBlock;

/*
 获取服务器原始数据(仅供下载放大图使用，当时使用人员提出的需求)
 */
- (NetService *)downLoadData:(NSString *)strRemoteURL
                originRetBlock:(YQOriginRetBlock)originRetBlock
                       failure:(YQRequestFailuer) failureBlock
                 progressBlock:(YQNetProgress)progressBlock;
/**
 *  获取请求的头部参数
 *
 *  @return
 */
- (NSDictionary *)getHttpHeaderParams;

- (NSString *)absoluteUrlString:(NSString *)relativeUrlPath;

@end
