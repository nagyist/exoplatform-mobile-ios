//
//  ActivityCalendarDetailMessageTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailMessageTableViewCell.h"

@interface ActivityCalendarDetailMessageTableViewCell : ActivityDetailMessageTableViewCell{
    RTLabel*                      _htmlMessage;
    RTLabel*                      _htmlName;
    RTLabel*                      _htmlTitle;
    CGFloat width;
}
@property (retain, nonatomic) RTLabel* htmlName;
@property (retain, nonatomic) RTLabel* htmlMessage;
@property (retain, nonatomic) RTLabel* htmlTitle;
@end
