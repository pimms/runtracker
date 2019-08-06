#ifndef NSValue_MKMapPoint_h
#define NSValue_MKMapPoint_h

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSValue (MKMapPoint)

+ (NSValue *)valueWithMKMapPoint:(MKMapPoint)mapPoint;
- (MKMapPoint)MKMapPointValue;

@end

#endif /* NSValue_MKMapPoint_h */
