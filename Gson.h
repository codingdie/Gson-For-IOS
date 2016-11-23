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

+ (NSArray*)fromDictionaryArray:(NSArray*)data toModelArray:(Class)cla;

+ (NSDictionary*)toDictionary:(id)obj;

+ (NSArray*)toDictionaryArray:(NSArray*)objArray;

+ (NSData*)toJsonData:(id)obj;

+ (NSString*)toJson:(id)obj;


+ (NSMutableArray* )getAllProperty:(Class) cla;

+ (void)getValue:(void*) value byPropName:(NSString*)propName from:(id) obj;

+ (void)setProperty:(NSString*)propertyName withValue:(void*)value for:(id)obj;

+ (void)setProperty:(NSString*)propName withObject:(id)value for:(id)obj;


@end
