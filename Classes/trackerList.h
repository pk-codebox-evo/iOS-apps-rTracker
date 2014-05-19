//
//  trackerList.h
//  rTracker
//
//  Created by Robert Miller on 16/03/2010.
//  Copyright 2010 Robert T. Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "/usr/include/sqlite3.h"
#import <sqlite3.h>

#import "tObjBase.h"
#import "trackerObj.h"

@interface trackerList : tObjBase {
	
	NSMutableArray *topLayoutNames;
	NSMutableArray *topLayoutIDs;
	NSMutableArray *topLayoutPriv;
    NSMutableArray *topLayoutReminderCount;
	//trackerObj *tObj;
	
}

@property (nonatomic,retain) NSMutableArray *topLayoutNames;
@property (nonatomic,retain) NSMutableArray *topLayoutIDs;
@property (nonatomic,retain) NSMutableArray *topLayoutPriv;
@property (nonatomic,retain) NSMutableArray *topLayoutReminderCount;
//@property (nonatomic,retain) trackerObj *tObj;

- (id) init;
- (void) dealloc;

- (void)loadTopLayoutTable;
- (void)confirmTopLayoutEntry:(trackerObj *)tObj;
- (void) addToTopLayoutTable:(trackerObj *)tObj;
- (void)reorderFromTLT;
- (void)reloadFromTLT;

- (int) getTIDfromIndex:(NSUInteger)ndx;
- (int) getPrivFromLoadedTID:(int)tid;

- (BOOL)checkTIDexists:(NSNumber*)tid;
- (int) getTIDfromName:(NSString*)str;
- (NSArray*) getTIDFromNameDb:(NSString*)str;

- (void) fixDictTID:(NSDictionary*)tdict;
- (void) updateTLtid:(int)old new:(int)new;
- (void) updateTID:(int)old new:(int)new;

- (trackerObj *) copyToConfig : (trackerObj *) srcTO;

- (void) deleteTrackerAllRow : (NSUInteger) row;
- (void) deleteTrackerRecordsRow : (NSUInteger) row;
- (void) reorderTLT : (NSUInteger) fromRow toRow:(NSUInteger)toRow;

//- (void) writeTListXLS:(NSFileHandle*)nsfh;
- (void) exportAll;

- (void) deConflict:(trackerObj*)newTracker;
- (void) wipeOrphans;
- (BOOL) recoverOrphans;


@end
