//
//  Gson.h
//  DocPatient
//
//  Created by yangjunhui on 15/9/17.
//  Copyright (c) 2015年 Yihua Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gson : NSObject


+ (id)fromJsonObject:(NSDictionary*)data toClass:(Class)cla;
+ (NSMutableArray*)fromJsonArray:(NSArray*)data toClass:(Class)cla;
+ (id)fromJsonString:(NSString *)content toModel:(Class)modelClass;
+ (id)fromJsonString:(NSString *)content toArray:(Class)modelClass;

+(NSDictionary*)toJson:(id)obj;
+(NSData*)toJsonData:(id)obj;
+(NSString*)toJsonString:(id)obj;





@end
