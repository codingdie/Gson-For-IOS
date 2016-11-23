//
//  Data.h
//  Gson
//
//  Created by yangjunhui on 15/9/18.
//  Copyright (c) 2015年 yangjunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Student;
@interface ClassRoom : NSObject
@property (nonatomic, assign) long  roomId;

@property (nonatomic, copy) NSString * roomName;
@property (nonatomic, strong) NSMutableArray*  students;
@property (nonatomic, strong) Student*  monitor;

//属性名字+数组里面对象的Class
-(Class)studentsClass;
@end
