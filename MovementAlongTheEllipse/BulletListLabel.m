//
//  BulletListLabel.m
//  ModelAlliance
//
//  Created by Виктория on 12.08.15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "BulletListLabel.h"

@implementation BulletListLabel

- (void)setTextForLabel:(NSString *)text forRole:(TypeForColor)typeColor{
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    if (typeColor == Pink) {
        attachment.image = [UIImage imageNamed:@"pink_paragraph_dot"];
    } else if (typeColor == Violet) {
        attachment.image = [UIImage imageNamed:@"orange_paragraph_dot"];
    } else {
        attachment.image = [UIImage imageNamed:@"paragraph_dot"];
    }
    
    attachment.bounds = (CGRect) {0, 2, attachment.image.size};
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableParagraphStyle *paragraphStyle;
    paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentRight;
    [paragraphStyle setTabStops:@[[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:10 options:@{}]]];
    
    [paragraphStyle setDefaultTabInterval:20];
    [paragraphStyle setFirstLineHeadIndent:0];
    [paragraphStyle setHeadIndent:20];
    
    NSMutableAttributedString *myString = [[NSMutableAttributedString alloc] initWithString:@""];
    [myString appendAttributedString:attachmentString];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
    [myString appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:20], NSFontAttributeName, nil]]];
    [myString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = myString;
    self.textAlignment = NSTextAlignmentLeft;
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

@end
