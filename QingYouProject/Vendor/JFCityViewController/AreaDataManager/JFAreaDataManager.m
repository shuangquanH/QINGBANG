//
//  JFAreaDataManager.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/18.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFAreaDataManager.h"

#import "FMDB.h"

@interface JFAreaDataManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation JFAreaDataManager

static JFAreaDataManager *manager = nil;
+ (JFAreaDataManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)getSQLData {
    
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"t_area.sqlite"];
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    self.db = db;
    
    //3.打开数据库
    if ([db open]) {
        //4.创表
        NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS t_area (area_id INTEGER ,area_number TEXT ,area_name TEXT ,city_number TEXT ,city_name TEXT ,longitude INTEGER ,latitude INTEGER ,create_by TEXT ,create_date TEXT ,update_by TEXT ,update_date TEXT ,remarks TEXT ,isdeleted INTEGER);";
        
//                          area_id, area_number, area_name, city_number, city_name
//INSERT INTO `t_area` VALUES (350, '140000', '山西省', '141100', '吕梁市', NULL, NULL, 'admin', '2018-06-05 16:50:26', NULL, NULL, NULL, 0);
        BOOL result = [db executeUpdate:sqlStr];
        
        if (result) {
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"t_area" ofType:@"sql"];
            NSError *error;
            NSString *sql = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            NSArray *array = [sql componentsSeparatedByString:@";"];
            for (NSString *str in array) {
                if ([self.db executeUpdate:str]) {
                    //插入数据成功
                } else {
//                    [YGAppTool showToastWithText:@"数据库出错！"];
                }
            }
        } else {
            NSLog(@"创表失败");
        }
    }
    
}

- (void)areaSqliteDBData {
    [self getSQLData];
    return;
}

- (void)getAllProvince:(void(^)(NSMutableArray *dataArray))provinces {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    FMResultSet *result = [self.db executeQuery:@"SELECT DISTINCT area_name FROM t_area;"];
    
    while ([result next]) {
        NSString *provinceName = [result stringForColumn:@"area_name"];
        [resultArray addObject:provinceName];
    }
    provinces(resultArray);
}
- (void)getCityWithProvinceName:(NSString *)province cities:(void (^)(NSMutableArray *dataArray))city {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT city_name FROM t_area WHERE area_name ='%@';",province];
    FMResultSet *result = [self.db executeQuery:sqlString];
    while ([result next]) {
        NSString *areaName = [result stringForColumn:@"city_name"];
        [resultArray addObject:areaName];
    }
    city(resultArray);
}
- (void)getCityIDWithCityName:(NSString *)cityName cityID:(void(^)(NSString *cityId))cityId {
    FMResultSet *result = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT area_id FROM t_area WHERE city_name = '%@';",cityName]];
    while ([result next]) {
        NSString *theId = [result stringForColumn:@"area_id"];
        cityId(theId);
    }
}





/// 所有市区的名称
- (void)cityData:(void (^)(NSMutableArray *dataArray))cityData {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    FMResultSet *result = [self.db executeQuery:@"SELECT DISTINCT city_name FROM t_area;"];
    while ([result next]) {
        NSString *cityName = [result stringForColumn:@"city_name"];
        [resultArray addObject:cityName];
    }
    cityData(resultArray);
}

/// 获取当前市的city_number
- (void)cityNumberWithCity:(NSString *)city cityNumber:(void (^)(NSString *cityNumber))cityNumber {
    FMResultSet *result = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT city_number FROM t_area WHERE city_name = '%@';",city]];
    while ([result next]) {
        NSString *number = [result stringForColumn:@"city_number"];
        cityNumber(number);
    }
}

/// 所有区县的名称
- (void)areaData:(NSString *)cityNumber areaData:(void (^)(NSMutableArray *areaData))areaData {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT area_name FROM t_area WHERE city_number ='%@';",cityNumber];
    FMResultSet *result = [self.db executeQuery:sqlString];
    while ([result next]) {
        NSString *areaName = [result stringForColumn:@"area_name"];
        [resultArray addObject:areaName];
    }
    areaData(resultArray);
}

/// 根据city_number获取当前城市
- (void)currentCity:(NSString *)cityNumber currentCityName:(void (^)(NSString *name))currentCityName {
    FMResultSet *result = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT city_name FROM t_area WHERE city_number = '%@';",cityNumber]];
    while ([result next]) {
        NSString *name = [result stringForColumn:@"city_name"];
        currentCityName(name);
    }
}

- (void)searchCityData:(NSString *)searchObject result:(void (^)(NSMutableArray *result))result {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    FMResultSet *areaResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT area_name,city_name,city_number FROM t_area WHERE area_name LIKE '%@%%';",searchObject]];
    while ([areaResult next]) {
        NSString *area = [areaResult stringForColumn:@"area_name"];
        NSString *city = [areaResult stringForColumn:@"city_name"];
        NSString *cityNumber = [areaResult stringForColumn:@"city_number"];
        NSDictionary *dataDic = @{@"super":city,@"city":area,@"city_number":cityNumber};
        [resultArray addObject:dataDic];
    }
    
    if (resultArray.count == 0) {
        FMResultSet *cityResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT city_name,city_number,province_name FROM t_area WHERE city_name LIKE '%@%%';",searchObject]];
            while ([cityResult next]) {
                NSString *city = [cityResult stringForColumn:@"city_name"];
                NSString *cityNumber = [cityResult stringForColumn:@"city_number"];
                NSString *province = [cityResult stringForColumn:@"province_name"];
                NSDictionary *dataDic = @{@"super":province,@"city":city,@"city_number":cityNumber};
                [resultArray addObject:dataDic];
            }
        
        if (resultArray.count == 0) {
            FMResultSet *provinceResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT province_name,city_name,city_number FROM t_area WHERE province_name LIKE '%@%%';",searchObject]];
            
            while ([provinceResult next]) {
                NSString *province = [provinceResult stringForColumn:@"province_name"];
                NSString *city = [provinceResult stringForColumn:@"city_name"];
                NSString *cityNumber = [provinceResult stringForColumn:@"city_number"];
                NSDictionary *dataDic = @{@"super":province,@"city":city,@"city_number":cityNumber};
                [resultArray addObject:dataDic];
            }
            
            //统一在数组中传字典是为了JFSearchView解析数据时方便
            if (resultArray.count == 0) {
                [resultArray addObject:@{@"city":@"抱歉",@"super":@"未找到相关位置，可尝试修改后重试!"}];
            }
        }
    }
    //返回结果
    result(resultArray);
}

@end







//// copy"area.sqlite"到Documents中
//NSFileManager *fileManager =[NSFileManager defaultManager];
//NSError *error;
//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//NSString *documentsDirectory =[paths objectAtIndex:0];
//NSString *txtPath =[documentsDirectory stringByAppendingPathComponent:@"t_area.sqlite"];
//if([fileManager fileExistsAtPath:txtPath] == NO){
//    NSString *resourcePath =[[NSBundle mainBundle] pathForResource:@"t_area" ofType:@"sqlite"];
//    [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
//}
//// 新建数据库并打开
//NSString *path  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"t_area.sqlite"];
//FMDatabase *db = [FMDatabase databaseWithPath:path];
//self.db = db;
//BOOL success = [db open];
//if (success) {
//    // 数据库创建成功!
//    NSLog(@"数据库创建成功!");
//    NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS t_area (area_id INTEGER ,area_number INTEGER ,area_name TEXT ,city_number INTEGER ,city_name TEXT ,province_number INTEGER ,province_name TEXT);";
//    BOOL successT = [self.db executeUpdate:sqlStr];
//    if (successT) {
//        // 创建表成功!
//
//        NSLog(@"创建表成功!");
//    }else{
//        // 创建表失败!
//        NSLog(@"创建表失败!");
//        [self.db close];
//    }
//}else{
//    // 数据库创建失败!
//    NSLog(@"数据库创建失败!");
//    [self.db close];
//}
