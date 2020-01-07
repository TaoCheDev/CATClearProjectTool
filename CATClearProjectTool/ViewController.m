//
//  ViewController.m
//  CATClearProjectTool
//
//  Created by CatchZeng on 15/12/29.
//  Copyright © 2015年 catch. All rights reserved.
//

#import "ViewController.h"
#import "CATClearProjectTool.h"

@interface ViewController()<CATClearProjectToolDelegate>

@property (weak) IBOutlet NSTextField *txtPath;
@property (unsafe_unretained) IBOutlet NSTextView *txtResult;
@property (unsafe_unretained) IBOutlet NSTextView *txtSaveFilter;
@property (unsafe_unretained) IBOutlet NSTextView *txtFilter;

@property (nonatomic, copy) NSString *saveFilterValue; /**< 保存文件初始值 */
@property (nonatomic, copy) NSString *unSaveFilterValue; /**< 不保存文件初始值 */

@property (nonatomic,strong) CATClearProjectTool* clearProjectTool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearProjectTool.delegate = self;
    
    self.saveFilterValue = @"";
    self.unSaveFilterValue = @"^Target_.*,MarsCar-Bridging-Header,GPUImageMovieComposition,GPUImageFramework,GPUImageFASTCornerDetectionFilter,HooDatePicker";
    
    self.txtSaveFilter.string = self.saveFilterValue;
    self.txtFilter.string = self.unSaveFilterValue;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark -- UIResponder

- (IBAction)searchButtonClicked:(id)sender {
    _txtResult.string = @"搜索中...";
    self.clearProjectTool.saveRegex = self.txtSaveFilter.string;
    self.clearProjectTool.unSaveRegex = self.txtFilter.string;
    
    NSString *path = _txtPath.stringValue;
    #warning 张鑫测试
    path = @"/Users/zhxin/work/iOS/MarsCarWorkspace/MarsCar/MarsCar.xcodeproj";
    [self.clearProjectTool startSearchWithXcodeprojFilePath:path];
}

- (IBAction)resetButtonClicked:(id)sender {
    _txtResult.string = @"";
    self.txtSaveFilter.string = self.saveFilterValue;
    self.txtFilter.string = self.unSaveFilterValue;
}

- (IBAction)clearButtonClicked:(id)sender {
    [self.clearProjectTool clearFileAndMetaData];
}

#pragma mark -- CATClearProjectToolDelegate

-(void)searchAllClassesSuccess:(NSMutableDictionary *)dic{
//    NSString* msg = @"Successfully searched all classes:\n";
//    dispatch_async(dispatch_get_main_queue(), ^{
//        _txtResult.string = [msg stringByAppendingString:[self _getClassNamesFromDic:dic]];
//    });
}

-(void)searchUnUsedClassesSuccess:(NSMutableDictionary *)dic{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = [self _getClassNamesFromDic:dic];
        if (str.length > 0) {
            str = [str substringFromIndex:1];
        }
        _txtResult.string = str.length > 0 ? str : @"很干净";
    });
}

-(void)clearUnUsedClassesSuccess:(NSMutableDictionary *)dic{
    NSString* msg = @"删除成功！ 已删除列表:\n";
    dispatch_async(dispatch_get_main_queue(), ^{
        _txtResult.string = [msg stringByAppendingString:[self _getClassNamesFromDic:dic]];
    });
}

#pragma mark -- helper

-(NSString *)_getClassNamesFromDic:(NSMutableDictionary *)dic{
    NSArray* keys = [dic allKeys];
    NSString* classNames = @"";
    for (NSString* className in keys) {
        classNames = [classNames stringByAppendingString:[NSString stringWithFormat:@"\n%@",className]];
    }
    return classNames;
}

#pragma mark -- properties

/**
 *  get clearProjectTool
 *
 *  @return clearProjectTool
 */
-(CATClearProjectTool *)clearProjectTool{
    if (!_clearProjectTool) {
        _clearProjectTool = [[CATClearProjectTool alloc]init];
    }
    return _clearProjectTool;
}


#pragma mark -- dealloc

-(void)dealloc{
    _clearProjectTool = nil;
}

@end
