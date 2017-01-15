# SGModleKeyValues
运行时字典转模型，模型快速转字典


## how to import for your project

  1、直接集成 (directly integrating)
  
  下载zip包解压后， 直接将 “SGModelKeyValues” 文件夹下所有文件拖到你的项目 (Download the zip package decompression, directly under the "SGModelKeyValues" folder to drag all your files to your project)
  
  
  2、使用CocoaPods  (use CocoaPods)
  
 To integrate SGDwonload into your Xcode project using CocoaPods, specify it in your Podfile:

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '8.0'
	
	target 'TargetName' do
	pod 'SGModleKeyValues', '~> 1.0.0'
	end
Then, run the following command:

	$ pod install




### 转化效率对比

#### 2、字典 --> 模型 

转化代码（均转化成功）：

	double time1 = CFAbsoluteTimeGetCurrent(); //记录开始时间
    NSArray * sgArrays = [SGFirstObject sg_objectArrayFromKeyValues:self.dataSource];
    double time2 = CFAbsoluteTimeGetCurrent(); //记录结束时间
    NSArray * mjArrays = [SGFirstObject mj_objectArrayWithKeyValuesArray:self.dataSource];
    double time3 = CFAbsoluteTimeGetCurrent(); //记录结束时间
    NSArray * yyArrays = [NSArray yy_modelArrayWithClass:[SGFirstObject class] json:self.dataSource];
    double time4 = CFAbsoluteTimeGetCurrent(); //记录结束时间
    NSLog(@"SG %f",time2-time1);
    NSLog(@"MJ %f",time3-time2);
    NSLog(@"YY %f",time4-time3);




##### 2、模型 --> 字典  效率对比

代码：

	NSArray * sgArrays = [SGFirstObject sg_objectArrayFromKeyValues:self.dataSource];
	double time1 = CFAbsoluteTimeGetCurrent(); //记录开始时间
    id sgKeyValues = [sgArrays sg_keyValues];
    double time2 = CFAbsoluteTimeGetCurrent(); //记录结束时间
    id mjKeyValues = [sgArrays mj_keyValues];
    double time3 = CFAbsoluteTimeGetCurrent(); //记录结束时间
    id yyKeyValues = [sgArrays yy_modelToJSONObject];
    double time4 = CFAbsoluteTimeGetCurrent(); //记录结束时间
    
    NSLog(@"SG %f",time2-time1);
    NSLog(@"MJ %f",time3-time2);
    NSLog(@"YY %f",time4-time3);
    
打印结果：
	
	po sgKeyValues
     {
     age = 18;
     dog =     {
     "nike_Name" = "\U54c8\U58eb\U5947";
     price = "123$";
     };
     first = testtest;
     firstTest = 893722y382738;
     firstTest1 = erewewcwevev;
     firstTest2 = erewew324ev;
     firstTest3 = erewewc4232ev;
     height = "1.78";
     indentifer = 9223372036854775807;
     name = jack;
     },
     
     po mjKeyValues < 转化失败:不能识别数组 >
     <__NSArrayM 0x600000245220>(
     <SGFirstObject: 0x6000000d6d50>,
     <SGFirstObject: 0x6000000d6dc0>,
     <SGFirstObject: 0x6000000d6e30>,
     <SGFirstObject: 0x6000000d6ea0>,
     <SGFirstObject: 0x6000000d6f10>,
     <SGFirstObject: 0x6000000d6f80>,
     <SGFirstObject: 0x6000000d6ff0>,
     <SGFirstObject: 0x6000000d70d0>
     )

      po yyKeyValues
     {
     age = 18;
     dog =     {
     "nike_Name" = "\U54c8\U58eb\U5947";
     price = "123$";
     };
     first = testtest;
     firstTest = 893722y382738;
     firstTest1 = erewewcwevev;
     firstTest2 = erewew324ev;
     firstTest3 = erewewc4232ev;
     height = "1.78";
     indentifer = 9223372036854775807;
     },

执行效率对比：
 	
 	
 	 2017-01-12 09:57:55.370 SGExtention[1812:46784] SG 0.000780
     2017-01-12 09:57:55.370 SGExtention[1812:46784] MJ 0.000280
     2017-01-12 09:57:55.370 SGExtention[1812:46784] YY 0.054711
     
     2017-01-12 09:57:55.370 SGExtention[1812:46784] SG 0.000780
     2017-01-12 09:57:55.370 SGExtention[1812:46784] MJ 0.000280
     2017-01-12 09:57:55.370 SGExtention[1812:46784] YY 0.054711
     
     2017-01-12 09:59:01.297 SGExtention[1812:46784] SG 0.000470
     2017-01-12 09:59:01.297 SGExtention[1812:46784] MJ 0.000019
     2017-01-12 09:59:01.297 SGExtention[1812:46784] YY 0.000122
     
     2017-01-12 09:59:07.034 SGExtention[1812:46784] SG 0.000410
     2017-01-12 09:59:07.035 SGExtention[1812:46784] MJ 0.000006
     2017-01-12 09:59:07.035 SGExtention[1812:46784] YY 0.000072
     
     2017-01-12 09:59:08.850 SGExtention[1812:46784] SG 0.000330
     2017-01-12 09:59:08.851 SGExtention[1812:46784] MJ 0.000005
     2017-01-12 09:59:08.851 SGExtention[1812:46784] YY 0.000073
     
     2017-01-12 09:59:09.827 SGExtention[1812:46784] SG 0.000425
     2017-01-12 09:59:09.827 SGExtention[1812:46784] MJ 0.000008
     2017-01-12 09:59:09.827 SGExtention[1812:46784] YY 0.000101
     
     2017-01-12 09:59:11.899 SGExtention[1812:46784] SG 0.000281
     2017-01-12 09:59:11.899 SGExtention[1812:46784] MJ 0.000005
     2017-01-12 09:59:11.899 SGExtention[1812:46784] YY 0.000064

     
     2017-01-12 10:01:43.746 SGExtention[1849:50563] SG 0.000793
     2017-01-12 10:01:43.746 SGExtention[1849:50563] MJ 0.000286
     2017-01-12 10:01:43.746 SGExtention[1849:50563] YY 0.013458
 
从打印结果来看:MJ用时最短，但是数组模型转字典模型失败；YY第一次转化用时较长，但转化一次之后转化效率大大提升; SG转化时间较稳定用时也较短