//
//  Gson.m
//  DocPatient
//
//  Created by yangjunhui on 15/9/17.
//  Copyright (c) 2015年 Yihua Cao. All rights reserved.
//

#import "Gson.h"
#import <objc/runtime.h>
#import "GsonProperty.h"

@implementation Gson

+(id)fromJsonObject:(NSDictionary*)data toClass:(Class)cla{
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id obj= [cla new];
    NSMutableArray*arry=[Gson getAllProperty:cla];
    for (GsonProperty *prop in arry)
    {
        NSString* propName=prop.name;
        
        if ([data objectForKey:propName] != nil)
        {
            NSString *typeStr =prop.type;
            if ([[typeStr lowercaseString] isEqualToString:@"i"]||[[typeStr lowercaseString] isEqualToString:@"s"])
            {
                int value=[[data valueForKey:propName] intValue];
                [Gson setProperty:propName withValue:&value for:obj];
                
            } else if ([[typeStr lowercaseString] isEqualToString:@"l"]||[[typeStr lowercaseString] isEqualToString:@"q"])
            {
                long value=[[data valueForKey:propName] longValue];
                [Gson setProperty:propName withValue:&value for:obj];
            }
            else if ([typeStr isEqualToString:@"@\"NSString\""])
            {
                NSString* value=[data valueForKey:propName] ;
                
                [Gson setProperty:propName withObject:value for:obj];
                
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
                        [value addObject:[Gson fromJsonObject:itemJson toClass:class]];
                    }
                    
                }
                [Gson setProperty:propName withObject:value for:obj];
            }else if([typeStr isEqualToString:@"d"]){
                double value=[[data valueForKey:propName] doubleValue];
                [Gson setProperty:propName withValue:&value for:obj];
            }else if ([typeStr isEqualToString:@"f"]){
                float value=[[data valueForKey:propName] floatValue];
                [Gson setProperty:propName withValue:&value for:obj];
            }else if([ typeStr rangeOfString:@"@"].location!=NSNotFound){
                [obj setValue:[Gson fromJsonObject:[data valueForKey:propName] toClass:NSClassFromString([typeStr substringWithRange:NSMakeRange(2, typeStr.length-3)])] forKey:propName];
            }     else{
                NSLog(@"不识别 propName:%@/typeStr:%@",propName,typeStr);
            }
        }
    }
    return obj;
}
+(NSMutableArray*)fromJsonArray:(NSArray*)data toClass:(Class)cla{
    
    if (![data isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray* arry=[NSMutableArray array];
    for (id obj in data) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [arry addObject:[Gson fromJsonObject:obj toClass:cla]];
        }else if ([obj isKindOfClass:[NSNumber class]]) {
            [arry addObject:obj];
        }
    }
    return arry;
}

+(NSDictionary*)toJson:(id) obj;
{
    if (obj==nil) {
        return [NSNull null];
    }
    NSMutableArray*arry=[Gson getAllProperty:[obj class]];
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionaryWithCapacity:[arry count]];
    
    for (GsonProperty*prop in arry)
    {
        NSString *propName = prop.name;
        NSString *typeStr = prop.type;
        
        if ([[typeStr lowercaseString] isEqualToString:@"i"]||[[typeStr lowercaseString] isEqualToString:@"s"])
        {
            int result = 0;
            [Gson getValue:&result byPropName:propName from:obj];
            [jsonDic setObject:@(result) forKey:propName];
        }else if ([[typeStr lowercaseString] isEqualToString:@"l"]||[[typeStr lowercaseString] isEqualToString:@"q"]){
            long result = 0;
            [Gson getValue:&result byPropName:propName from:obj];
            [jsonDic setObject:@(result) forKey:propName];
        }
        else if ([typeStr isEqualToString:@"@\"NSString\""])
        {
            NSString *value = [obj performSelector:NSSelectorFromString(propName) withObject:nil];
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
                    [jsonValue addObject:[Gson toJson:item]];
                }
            }
            [jsonDic setObject:jsonValue forKey:propName];
        }else if([typeStr isEqualToString:@"d"]){
            double result = 0;
            [Gson getValue:&result byPropName:propName from:obj];
            [jsonDic setObject:@(result) forKey:propName];
        }else if ([typeStr isEqualToString:@"f"]){
            float result = 0;
            [Gson getValue:&result byPropName:propName from:obj];
            [jsonDic setObject:@(result) forKey:propName];
        }else if([ typeStr rangeOfString:@"@"].location!=NSNotFound){
            [jsonDic setObject:[Gson toJson:[obj valueForKey:propName]] forKey:propName];
        }else{
            NSLog(@"不识别 propName:%@/typeStr:%@",propName,typeStr);
        }
    }
    
    return jsonDic;
}

+(void)getValue:(void*) value byPropName:(NSString*)propName from:(id) obj{
    SEL selector = NSSelectorFromString(propName);
    NSMethodSignature *signature = [[obj class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:obj];
    [invocation setSelector:selector];
    [invocation invoke];
    [invocation getReturnValue:value];
}

+ (void)setProperty:(NSString*)propertyName withValue:(void*)value for:(id)obj
{
    NSString *setterName = [NSString stringWithFormat:@"set%@%@:", [propertyName substringToIndex:1].uppercaseString, [propertyName substringFromIndex:1]];
    SEL selector = NSSelectorFromString(setterName);
    NSMethodSignature *signature = [[obj class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:obj];
    [invocation setSelector:selector];
    [invocation setArgument:value atIndex:2];
    [invocation invoke];
}

+ (void)setProperty:(NSString*)propName withObject:(id)value for:(id)obj
{
    NSString *setterName = [NSString stringWithFormat:@"set%@%@:", [propName substringToIndex:1].uppercaseString, [propName substringFromIndex:1]];
    [obj performSelector:NSSelectorFromString(setterName) withObject:value];
}

+(NSData*)toJsonData:(id) obj{
    if (!obj) {
        return nil;
    }
    
    NSDictionary*jsondic=nil;
    if ([obj isKindOfClass:[NSDictionary class]]||[obj isKindOfClass:[NSMutableDictionary class]]) {
        jsondic=obj;
    }else{
        jsondic=[Gson toJson:obj];
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsondic
                                                       options:0
                                                         error:&error];
    if (error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+(NSString *)toJsonString:(id)obj
{
    NSData *data = [Gson toJsonData:obj];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+(NSMutableArray* )getAllProperty:(Class) cla{
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
        GsonProperty*pro = [[GsonProperty alloc]init];
        pro.name=propName;
        pro.type=typeStr;
        [arry addObject:pro];
    }
    free(props);
    if ([cla superclass]!=nil) {
        [arry addObjectsFromArray:[Gson getAllProperty:[cla superclass]]]  ;
    }
    return arry;
}

+ (id)fromJsonString:(NSString *)content toModel:(Class)modelClass
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (!data)
    {
        return nil;
    }
    NSError *error;
    NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return nil;
    }
    return [Gson fromJsonObject:messageDict toClass:modelClass];
}


@end
