//
//  YWDictionary.m
//  Created by Justin Baker on 9/4/12.
//

#import "YWDictionary.h"

@implementation YWDictionary

@synthesize keys, values;

// Initializes a new YWDictionary
- (id) init
{
    if ((self = [super init])) {
        keys = [[NSMutableArray alloc] init];
        values = [[NSMutableArray alloc] init];
    }
    return self;
}

// Adds a given key-value pair to the dictionary.
- (void) setObject: (id)obj forKey:(NSString *)key
{
    NSUInteger index = [keys indexOfObject:key];
    if(index != NSIntegerMax){
        [values replaceObjectAtIndex:index withObject:obj]; 
        return;
    }
    // tack it onto the end
    [keys addObject: key];
    [values addObject: obj];
}

// Adds several key-value pairs to the dictionary.
- (void) setObjects: (NSArray *)vals forKeys:(NSArray *)ks
{
    int index = 0;
    for(NSString *key in ks)
    {
        [self setObject:[vals objectAtIndex:index] forKey:key];
        index++;
    }
}

// Returns the value associated with a given key.
- (id) objectForKey: (NSString *)key
{
    int index = [keys indexOfObject:key];
    return [values objectAtIndex:index];
}

// Returns the key associated with a given value
- (NSString *) keyForObject: (id) obj
{
    int index = [values indexOfObject:obj];
    return [keys objectAtIndex:index];
}

// Removes a given key and its associated value from the dictionary.
- (void) removeObjectWithKey: (NSString *)key
{
    int index = [keys indexOfObject:key];
    [keys removeObjectAtIndex:index];
    [values removeObjectAtIndex:index];
}

// Removes all objects from dictionary
- (void) clear
{
    [keys removeAllObjects];
    [values removeAllObjects];
}

// Returns a new array containing the dictionary’s keys.
- (NSArray *) allKeys
{
    return keys;
}
// Returns a new array containing the dictionary’s values
- (NSArray *) allValues
{
    return values;
}

// Returns an enumerator object that lets you access each key in the dictionary.
- (NSEnumerator *) keyEnumerator
{
    return [keys objectEnumerator];
}

// Returns an enumerator object that lets you access each value in the dictionary.
- (NSEnumerator *) valueEnumerator
{
    return [values objectEnumerator];
}

// Returns the number of entries in the dictionary.
- (int) count
{
    return [keys count];
}

// Sorts the dictionary in place comparing the values using a selector
- (id) sortByValuesWithSelector: (SEL) selector
{
    NSMutableArray *sortedKeys = [[NSMutableArray alloc] init];
    NSMutableArray *sortedValues = [[[self allValues] sortedArrayUsingSelector:selector] mutableCopy];
    for(id value in sortedValues){
        NSString *key = [self keyForObject:value];
        [sortedKeys addObject: key];
    }
    self.keys = sortedKeys;
    self.values = sortedValues;
    return self;
}

// Sorts the dictionary in place comparing the keys using a selector
- (id) sortByKeysWithSelector: (SEL) selector
{
    NSMutableArray *sortedKeys = [[[self allKeys] sortedArrayUsingSelector:selector] mutableCopy]; 
    NSMutableArray *sortedValues = [[NSMutableArray alloc] init];
    for(id key in sortedKeys){
        id obj = [self objectForKey:key];
        [sortedValues addObject: obj];
    }
    self.keys = sortedKeys;
    self.values = sortedValues;
    return self;
}

// Sorts the dictionary by values using caseInsensitiveCompare:
// Any object that responds to caseInsensitiveCompare: can use this to sort
- (id) sortByValues
{
    return [self sortByValuesWithSelector:@selector(caseInsensitiveCompare:)];
}

// Sorts the dictionary by keys using caseInsensitiveCompare:
// Any object that responds to caseInsensitiveCompare: can use this to sort
- (id) sortByKeys
{
    return [self sortByKeysWithSelector:@selector(caseInsensitiveCompare:)];
}

@end
