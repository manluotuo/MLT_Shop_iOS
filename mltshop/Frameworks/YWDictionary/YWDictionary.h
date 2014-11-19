//
//  YWDictionary.h
//  Created by Justin Baker on 9/4/12.
//

#import <Foundation/Foundation.h>

@interface YWDictionary : NSObject

@property(atomic, strong) NSMutableArray *keys, *values;

- (id) init;

- (void) setObject: (id)obj forKey:(NSString *)key;
- (void) setObjects: (NSArray *)values forKeys:(NSArray *)keys;

- (id) objectForKey: (NSString *)key;
- (NSString *) keyForObject: (id) obj;

- (void) removeObjectWithKey: (NSString *)key;
- (void) clear;

- (NSArray *) allKeys;
- (NSArray *) allValues;

- (NSEnumerator *) keyEnumerator;
- (NSEnumerator *) valueEnumerator;

- (int) count;

- (id) sortByValuesWithSelector: (SEL) selector;
- (id) sortByKeysWithSelector: (SEL) selector;
- (id) sortByValues;
- (id) sortByKeys;

@end
