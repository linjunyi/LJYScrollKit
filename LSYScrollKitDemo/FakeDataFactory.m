//
//  FakeDataFactory.m
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/28.
//

#import "FakeDataFactory.h"

@implementation HotTextModel

@end

@implementation FakeDataFactory

+ (NSArray *)HotTextData {
    HotTextModel *(^createModel)(NSDictionary *) = ^(NSDictionary *dic) {
        HotTextModel *model = [HotTextModel new];
        model.name = dic[@"name"];
        model.author = dic[@"author"];
        model.publisher = dic[@"publisher"];
        model.imgUrl = dic[@"imgUrl"];
        return model;
    };
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hotText.txt" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *dic in array) {
        [result addObject:createModel(dic)];
    }
    return result;
}

@end
