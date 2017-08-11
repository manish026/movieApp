//
//  BlueBorderedTextField.m
//  movieApp
//
//  Created by Manish on 11/08/17.
//  Copyright © 2017 Manish. All rights reserved.
//

#import "BlueBorderedTextField.h"


@implementation BlueBorderedTextField

@synthesize border,borderWidth;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setCustomView];
    
}

- (void)prepareForInterfaceBuilder {
    
    [self setCustomView];
}

- (void)setCustomView{
    
    [self.layer setCornerRadius:border];
    [self.layer setBorderColor:movieBlueColor.CGColor];
    [self.layer setBorderWidth:borderWidth];
}

@end
