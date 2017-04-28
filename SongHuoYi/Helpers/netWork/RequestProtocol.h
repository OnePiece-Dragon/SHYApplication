//
//  RequestProtocol.h
//  SongHuoYi
//
//  Created by 王亚龙 on 2017/4/27.
//  Copyright © 2017年 TianXi. All rights reserved.
//

#ifndef RequestProtocol_h
#define RequestProtocol_h

@protocol RequestResultProtocol <NSObject>

-(void)fetchResponse:(id)responseObj
                code:(BOOL)code
               fail:(NSString*)fail;

@end

@protocol RequestProtocol <NSObject>

- (void)requestWithMethod:(NSString*)method
                    param:(NSDictionary*)param
                 observer:(id<RequestResultProtocol>)observer;

@end


#endif /* RequestProtocol_h */
