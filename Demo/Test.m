//
//  main.m
//  Gson
//
//  Created by yangjunhui on 15/9/18.
//  Copyright (c) 2015年 yangjunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gson.h"
#import "Student.h"
#import "ClassRoom.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //基本对象
        NSString* objectJsonStr=@"{\"studentId\":2,\"studentName\":\"8班2号学生\"}";
        Student * student=[Gson fromJsonStr:objectJsonStr toModel:[Student class]];
        
        //基本对象的数组
        NSString* objectsJsonStr =@"[{\"studentId\":1,\"studentName\":\"8班1号学生\"},{\"studentId\":2,\"studentName\":\"8班2号学生\"},{\"studentId\":3,\"studentName\":\"8班3号学生\"},{\"studentId\":4,\"studentName\":\"8班4号学生\"},{\"studentId\":5,\"studentName\":\"8班5号学生\"},{\"studentId\":6,\"studentName\":\"8班6号学生\"},{\"studentId\":7,\"studentName\":\"8班7号学生\"},{\"studentId\":8,\"studentName\":\"8班8号学生\"},{\"studentId\":9,\"studentName\":\"8班9号学生\"}]";
        NSArray * students=[Gson fromJsonStr:objectsJsonStr toArray:[Student class]];
        
       //复合对象一个对象包含另一个对象活着数组
        NSString* objectWithArrayAndObject =@"{\"roomId\":1,\"roomName\":\"1班\",\"monitor\":{\"studentId\":3,\"studentName\":\"1班3号学生\"},\"students\":[{\"studentId\":1,\"studentName\":\"1班1号学生\"},{\"studentId\":2,\"studentName\":\"1班2号学生\"},{\"studentId\":3,\"studentName\":\"1班3号学生\"}]}";
        ClassRoom * classRoom=[Gson fromJsonStr:objectWithArrayAndObject toModel:[ClassRoom class]];
      
       //复合对象(一个对象包含另一个对象或者数组)的数组
        NSString* objectWithArrayAndObjectList =@"[{\"roomId\":1,\"roomName\":\"1班\",\"monitor\":{\"studentId\":3,\"studentName\":\"1班3号学生\"},\"students\":[{\"studentId\":1,\"studentName\":\"1班1号学生\"},{\"studentId\":2,\"studentName\":\"1班2号学生\"},{\"studentId\":3,\"studentName\":\"1班3号学生\"}]},{\"roomId\":2,\"roomName\":\"2班\",\"monitor\":{\"studentId\":3,\"studentName\":\"2班3号学生\"},\"students\":[{\"studentId\":1,\"studentName\":\"2班1号学生\"},{\"studentId\":2,\"studentName\":\"2班2号学生\"},{\"studentId\":3,\"studentName\":\"2班3号学生\"}]},{\"roomId\":3,\"roomName\":\"3班\",\"monitor\":{\"studentId\":2,\"studentName\":\"3班2号学生\"},\"students\":[{\"studentId\":1,\"studentName\":\"3班1号学生\"},{\"studentId\":2,\"studentName\":\"3班2号学生\"}]}]";
        NSArray * classRooms=[Gson fromJsonStr:objectWithArrayAndObjectList toArray:[ClassRoom class]];

        //任意对象转json字符串，复杂对象处理和上面一样
        NSLog(@"%@",[Gson toJson:classRooms]);

        
    }
    return 0;


}
