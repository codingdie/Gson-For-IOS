//
//  Gson.h
//  DocPatient
//
//  Created by yangjunhui on 15/9/17.
//  Copyright (c) 2015年 XUPENG. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Gson : NSObject

+ (id)fromJsonStr:(NSString *)content toModel:(Class)modelClass;

+ (NSArray*)fromJsonStr:(NSString *)content toArray:(Class)modelClass;

+ (id)fromDictionary:(NSDictionary*)data toModel:(Class)cla;

+ (NSString*)toJson:(id)obj;

+ (NSData*)toJsonData:(id)obj;

+ (NSArray*)fromDictionaryArray:(NSArray*)data toModelArray:(Class)cla;

+ (NSDictionary*)toDictionary:(id)obj;

+ (NSArray*)toDictionaryArray:(NSArray*)objArray;



+ (NSMutableArray* )getAllProperty:(Class) cla;


@end
