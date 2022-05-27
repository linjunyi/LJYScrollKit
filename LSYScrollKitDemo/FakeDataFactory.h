//
//  FakeDataFactory.h
//  LSYScrollKitDemo
//
//  Created by 林君毅 on 2022/5/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotTextModel : NSObject

@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *publisher;

@end


@interface FakeDataFactory : NSObject

+ (NSArray *)HotTextData;

@end

NS_ASSUME_NONNULL_END
