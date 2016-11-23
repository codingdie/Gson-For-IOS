# Gson-For-IOS
Gson coded by OC
一个轻量级无侵入使用及其简单的json映射框架。参考google的Gson框架。
特点:轻量只有一个文件可自己扩展，不需要继承也不需要实现协议。性能和yykit差不多，支持各种对象集合无限嵌套。

+ (id)fromJsonStr:(NSString *)content toModel:(Class)modelClass;

+ (NSArray*)fromJsonStr:(NSString *)content toArray:(Class)modelClass;

+ (id)fromDictionary:(NSDictionary*)data toModel:(Class)cla;

+ (NSString*)toJson:(id)obj;

+ (NSData*)toJsonData:(id)obj;
```
@class Student;
@interface ClassRoom : NSObject
@property (nonatomic, assign) long  roomId;

@property (nonatomic, copy) NSString * roomName;
@property (nonatomic, strong) NSMutableArray*  students;
@property (nonatomic, strong) Student*  monitor;

//属性名字+数组里面对象的Class
-(Class)studentsClass;
@end
@implementation ClassRoom
- (Class)studentsClass{
    return [Student class];
}


@interface Student : NSObject
@property (nonatomic, assign) long  studentId;
@property (nonatomic, copy) NSString * studentName;
@end


```
```

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
```
