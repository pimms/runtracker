#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "NSValue+MKMapPoint.h"

@implementation NSValue (MKMapPoint)

+ (NSValue *)valueWithMKMapPoint:(MKMapPoint)mapPoint {
    return [NSValue value:&mapPoint withObjCType:@encode(MKMapPoint)];
}

- (MKMapPoint)MKMapPointValue {
    MKMapPoint mapPoint;
    [self getValue:&mapPoint];
    return mapPoint;
}

@end
