require 'pathname'
require 'fileutils'

dirs = [
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191009/11845053',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191009/13645703',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191009/13645741',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191009/13748509',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191009/13765053',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191009/13801301',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191009/14048750',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191009/17370612',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191021/13645690',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191021/13645764',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191021/13678675',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191021/13764320',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191113/12109952',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191113/12169736',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191113/12183401',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191113/12204768',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191113/12356579',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191122/11903954',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191122/11968098',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191122/11982832',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191122/12156495',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191122/12169831',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191122/12173630',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191122/12183445',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191122/12199932',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191122/13871786',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12156527',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12173788',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12190193',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12195187',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12200184',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12321725',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12327093',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12333119',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12337719',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12340620',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12357987',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12358007',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12383699',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12491770',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12491887',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12491904',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12605110',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12605144',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12605200',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12630384',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/13918568',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/2135312',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/23019780',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/2623196',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/11861699',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/11879169',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/11929738',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/11940575',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/11940595',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/11982885',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/12173711',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/12183627',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/12189999',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/12265814',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/12303567',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/12307612',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/12321946',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/12358000',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/12383724',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/12568455',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20200102/13881867',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191009/13651543',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191009/13748263',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191021/13645748',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191113/11950372',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191113/12008411',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191113/12008430',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191113/12183280',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191113/12183605',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191113/12324989',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191113/17458138',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191122/11955021',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191122/12200029',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191122/12303581',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191122/12356628',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191122/12568529',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/11965193',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12014489',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12156579',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12156590',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12190232',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12327131',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12340579',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12356922',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12491813',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12491860',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12630354',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12630399',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/13918554',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/2129697',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/2129904',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/2606509',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/30468200',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/11950224',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/11950424',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/11982851',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12003772',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12045652',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12045669',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12128006',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12173462',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12190161',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12200129',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12204737',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12265692',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12307649',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12321882',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12321965',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12356835',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/12769928',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/13645675',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/13877295',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20200102/17458201',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/11827785',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/11855306',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13645626',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13645642',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13645658',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13645898',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13650119',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13678632',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13768829',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13800917',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13801237',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13801268',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13996087',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13996099',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/13996158',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191009/14046200',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191021/13715456',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191021/13764313',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191021/13768841',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191021/17821341',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11861652',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11861728',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11861761',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11892386',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11925310',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11940443',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11950535',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11965138',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11965210',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11965232',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11965258',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11965328',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11968177',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11975011',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11976402',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11976450',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11982779',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/11982873',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12031692',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12045723',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12139007',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12156604',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12190007',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12190142',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12190152',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12200079',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12219664',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12219681',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12265502',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12265650',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12265700',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12265743',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12265776',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12325031',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/12769940',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/13737856',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191113/13918500',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/11903971',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/11940607',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/11946771',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/11950507',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/11955163',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/11955247',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/11955304',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/11982809',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12031652',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12139017',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12156544',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12156554',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12169902',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12169997',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12173493',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12173511',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12183319',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12183467',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12190310',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12204746',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12219761',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12219793',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12265792',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12321791',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12321912',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12322038',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12322161',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12325011',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12337736',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12337768',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12630418',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/12793635',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20191122/13882008',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/11929776',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/11954970',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/11955081',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/11955209',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/11965279',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/11982765',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12003812',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12003837',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12008350',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12030997',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12045762',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12109891',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12109963',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12156565',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12169506',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12169810',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12170037',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12173965',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12183338',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12190017',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12190031',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12190039',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12190176',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12190374',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12199848',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12199959',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12200066',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12200110',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12200151',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12265710',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12265729',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12265752',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12265836',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12303697',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12321815',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12321840',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12321991',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12322011',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12325225',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12333139',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12356599',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12356683',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12605219',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12630409',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/13029127',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/13645886',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/13800892',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/13801246',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/13998143',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/17386994',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/17458207',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191009/13645730',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191113/12086482',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191122/12204689',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191122/12325250',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191218/12169971',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191218/12340590',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191218/12340611',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191218/12630367',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191218/12878519',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191218/13918547',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191218/13918578',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20191218/14072848',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20200102/11940417',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20200102/11955182',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20200102/12045732',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20200102/12204755',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20200102/12322054',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20200102/12358014',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20200102/13918537',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20200102/17370368',
  'P:/DigitalProjects/_TDD/4_to_metadata/5_Digital_problem_children/Batch_20200102/8348546',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12337757',
  'P:/DigitalProjects/_TDD/4_to_metadata/1_Copyrighted/Batch_20191218/12605235',
  'P:/DigitalProjects/_TDD/4_to_metadata/2_No_copyright_mark/Batch_20191218/12487052',
  'P:/DigitalProjects/_TDD/4_to_metadata/3_Borrower_notice/Batch_20200102/12190357'
]

other = [
  'P:/DigitalProjects/_TDD/4_to_metadata/4_other/17409791'
]

rework_dir = Pathname.new('P:\DigitalProjects\_TDD\3_to_ocr\0_staging\ocr-rework')
dirs.each do |dir|
  path = Pathname.new(dir)
  volume = path.basename
  sort_path, batch = path.parent.split
  sort_dir = sort_path.basename
  new_path = rework_dir.join(sort_dir, batch, volume)
  FileUtils.mkdir_p new_path
  FileUtils.cp path.join('metadata.txt'), new_path.join('metadata.txt')
end