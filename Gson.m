//
//  Gson.m
//  DocPatient
//
//  Created by yangjunhui on 15/9/17.
//  Copyright (c) 2015年 Yihua Cao. All rights reserved.
//

#import "Gson.h"
#import <objc/runtime.h>
static NSCache*gsonClassCache=nil;

@implementation Gson

+(id)fromDictionary:(NSDictionary*)data toModel:(Class)cla{
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id obj= [cla new];
    NSMutableArray*arry=[Gson getAllProperty:cla];
    for (NSDictionary *prop in arry)
    {
        NSString* propName=prop[@"name"];
        
        if ([data objectForKey:propName] != nil)
        {
            NSString *typeStr =prop[@"type"];

            if ([[typeStr lowercaseString] isEqualToString:@"i"]||[[typeStr lowercaseString] isEqualToString:@"s"])
            {
                int value=[[data valueForKey:propName] intValue];
                [obj setValue:@(value) forKey:propName];
                
            } else if ([[typeStr lowercaseString] isEqualToString:@"l"]||[[typeStr lowercaseString] isEqualToString:@"q"])
            {
                long value=[[data valueForKey:propName] longValue];
                [obj setValue:@(value) forKey:propName];
            }
            else if ([typeStr isEqualToString:@"@\"NSString\""])
            {
                NSString* value=[data valueForKey:propName] ;
                [obj setValue:value forKey:propName];
            }
            else if ([typeStr isEqualToString:@"@\"NSMutableArray\""]||[typeStr isEqualToString:@"@\"NSArray\""])            {
                NSArray *listJson = [data objectForKey:propName];
                NSMutableArray *value = [NSMutableArray arrayWithCapacity:listJson.count];
                for (id itemJson in listJson)
                {
                    if([itemJson isKindOfClass:[NSString class]]){
                        [value addObject:itemJson];
                    }else if ([itemJson isKindOfClass:[NSNumber class]]){
                        [value addObject:itemJson];
                    } else{
                        Class class = [obj performSelector:NSSelectorFromString([propName stringByAppendingString:@"Class"]) withObject:nil];
                        [value addObject:[Gson fromDictionary:itemJson toModel:class]];
                    }
                    
                }
                [obj setValue:value forKey:propName];
            }else if([typeStr isEqualToString:@"d"]){
                double value=[[data valueForKey:propName] doubleValue];
                [obj setValue:@(value) forKey:propName];
            }else if ([typeStr isEqualToString:@"f"]){
                float value=[[data valueForKey:propName] floatValue];
                [obj setValue:@(value) forKey:propName];
            }else if([ typeStr rangeOfString:@"@"].location!=NSNotFound){
                [obj setValue:[Gson fromDictionary:[data valueForKey:propName] toModel:NSClassFromString([typeStr substringWithRange:NSMakeRange(2, typeStr.length-3)])] forKey:propName];
            }     else{
                NSLog(@"不识别 propName:%@/typeStr:%@",propName,typeStr);
            }
        }
    }
    return obj;
}
+(NSMutableArray*)fromDictionaryArray:(NSArray*)data toModelArray:(Class)cla{
    
    if (![data isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray* arry=[NSMutableArray array];
    for (id obj in data) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [arry addObject:[Gson fromDictionary:obj toModel:cla]];
        }else if ([obj isKindOfClass:[NSNumber class]]) {
            [arry addObject:obj];
        }
    }
    return arry;
}

+(NSDictionary*)toDictionary:(id) obj;
{
    if (obj==nil) {
        return nil;
    }
    NSMutableArray*arry=[Gson getAllProperty:[obj class]];
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionaryWithCapacity:[arry count]];
    
    for (NSDictionary*prop in arry)
    {
        NSString *propName = prop[@"name"];
        NSString *typeStr = prop[@"type"];
        
        if ([[typeStr lowercaseString] isEqualToString:@"i"]||[[typeStr lowercaseString] isEqualToString:@"s"])
        {
            [jsonDic setObject:[obj valueForKey:propName] forKey:propName];
        }else if ([[typeStr lowercaseString] isEqualToString:@"l"]||[[typeStr lowercaseString] isEqualToString:@"q"]){
            [jsonDic setObject:[obj valueForKey:propName] forKey:propName];
        }
        else if ([typeStr isEqualToString:@"@\"NSString\""])
        {
            NSString *value = [obj valueForKey:propName];
            if(value!=nil){
                [jsonDic setObject:value forKey:propName];
            }
        }
        else if ([typeStr isEqualToString:@"@\"NSMutableArray\""]||[typeStr isEqualToString:@"@\"NSArray\""])
        {
            NSMutableArray *value = [obj performSelector:NSSelectorFromString(propName) withObject:nil];
            
            NSMutableArray *jsonValue = [NSMutableArray arrayWithCapacity:value.count];
            for (id item in value)
            {
                if ([item isKindOfClass:[NSString class]]) {
                    [jsonValue addObject:item];
                } else if([item isKindOfClass:[NSNumber class]]){
                    [jsonValue addObject:item];
                }else {
                    [jsonValue addObject:[Gson toDictionary:item]];
                }
            }
            [jsonDic setObject:jsonValue forKey:propName];
        }else if([typeStr isEqualToString:@"d"]){
            [jsonDic setObject:[obj valueForKey:propName] forKey:propName];
        }else if ([typeStr isEqualToString:@"f"]){
            [jsonDic setObject:[obj valueForKey:propName] forKey:propName];
        }else if([ typeStr rangeOfString:@"@"].location!=NSNotFound){
            [jsonDic setObject:[Gson toDictionary:[obj valueForKey:propName]] forKey:propName];
        }else{
            NSLog(@"不识别 propName:%@/typeStr:%@",propName,typeStr);
        }
    }
    
    return jsonDic;
}

+ (NSArray*)toDictionaryArray:(NSArray*)objArray{
    NSMutableArray *dicArray=[[NSMutableArray alloc] init];
    for(id obj in objArray){
        [dicArray addObject:[Gson toDictionary:obj]];
    }
    return dicArray;
}


+(NSData*)toJsonData:(id) obj{
    if (!obj) {
        return nil;
    }
    NSData *jsonData = nil;
    NSError *error = nil;
    if ([obj isKindOfClass:[NSDictionary class]]||[obj isKindOfClass:[NSMutableDictionary class]]) {
        jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0  error:&error];
    } else if ([obj isKindOfClass:[NSArray class]]||[obj isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *jsonArray = [NSMutableArray array];
        for (id childObj in obj) {
            NSDictionary *jsondic = [Gson toDictionary:childObj];
            [jsonArray addObject:jsondic];
        }
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:0  error:&error];
    } else {
       NSDictionary *jsondic=[Gson toDictionary:obj];
        jsonData = [NSJSONSerialization dataWithJSONObject:jsondic options:0  error:&error];
    }
    
    if (error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+(NSString *)toJson:(id)obj
{
    NSData *data = [Gson toJsonData:obj];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+(NSArray* )getAllProperty:(Class) cla{
    if(gsonClassCache==nil){
        gsonClassCache=[[NSCache alloc] init];
        gsonClassCache.countLimit=150;
    }
    NSArray * cache=[gsonClassCache objectForKey:cla];
    if(cache!=nil){
        return  cache;
    }
    NSString* className= [NSString stringWithUTF8String:class_getName(cla)];
    if ([className isEqualToString:@"NSObject"]) {
        return [NSMutableArray array];
    }
    NSMutableArray* arry=[NSMutableArray array];
    unsigned int count;
    objc_property_t *props = class_copyPropertyList(cla, &count);
    for (int i=0; i<count; i++) {
        NSString *propName = [NSString stringWithUTF8String:property_getName(props[i])];
        char *typeValue = property_copyAttributeValue(props[i], "T");
        NSString *typeStr = [NSString stringWithUTF8String:typeValue];
        free(typeValue);
        NSDictionary *pro = [NSDictionary dictionaryWithObjectsAndKeys:
                              propName, @"name",
                            typeStr, @"type",
                              nil];
 
        [arry addObject:pro];
    }
    free(props);
    if ([cla superclass]!=nil) {
        [arry addObjectsFromArray:[Gson getAllProperty:[cla superclass]]]  ;
    }
    [gsonClassCache setObject:arry forKey:cla];

    return arry;
}

+ (id)fromJsonStr:(NSString *)content toModel:(Class)modelClass
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (!data)
    {
        return nil;
    }
    NSError *error;
    id message = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    if ([message isKindOfClass:[NSDictionary class]] || [message isKindOfClass:[NSMutableDictionary class]]) {
        return [Gson fromDictionary:message toModel:modelClass];
    } else if ([message isKindOfClass:[NSArray class]] || [message isKindOfClass:[NSMutableArray class]]) {
        NSLog(@"error:not a jsonObject,is jsonArray");

        return nil;
    }
    return nil;
}

+ (id)fromJsonStr:(NSString *)content toArray:(Class)modelClass
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (!data)
    {
        return nil;
    }
    NSError *error;
    id message = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    if ([message isKindOfClass:[NSDictionary class]] || [message isKindOfClass:[NSMutableDictionary class]]) {
        NSLog(@"error:not a jsonArray ,is jsonObject");
        return nil;
    } else if ([message isKindOfClass:[NSArray class]] || [message isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *modelClassList = [NSMutableArray array];
        for (id obj in message) {
            id model = [Gson fromDictionary:obj toModel:modelClass];
            [modelClassList addObject:model];
        }
        return modelClassList;
    }
    return nil;
}
@end
