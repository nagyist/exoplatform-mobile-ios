//
//  ActivityWikiDetailMessageTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailMessageTableViewCell.h"

@interface ActivityWikiDetailMessageTableViewCell : ActivityDetailMessageTableViewCell{
    RTLabel*                      _htmlMessage;
    RTLabel*                      _htmlName;
    
    CGFloat width;
}
@property (retain, nonatomic) RTLabel* htmlMessage;
@property (retain, nonatomic) RTLabel* htmlName;
@end
