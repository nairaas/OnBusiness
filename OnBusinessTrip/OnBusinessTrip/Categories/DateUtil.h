//
//  DateUtil.h
//  AtTask
//
//  Created by Mikayel Aghasyan on 8/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DateFormatMMMDDYYYY,
	DateFormatMMMDD
} DateFormat;

#define ONE_DAY_TIME_INETRVAL 86400

@interface DateUtil : NSObject {}

/**
 * @return Returns date string which represent @param dt in the following format:
 * "MMM dd, yyyy"
 */
+ (NSString *)stringFromDate:(NSDate *)dt;

/**
 * @return Returns date string which represent @param dt in the following format:
 * "MMM dd" - if @param fullMonth is NO
 * "MMMM dd" - if @param fullMonth is YES
 */
+ (NSString *)shortStringFromDate:(NSDate *)dt fullMonth:(BOOL)fullMonth;

/**
 * @return Returns date string which represent @param dt in the following format:
 * "MMM d, yyyy HH:mm a"
 */
+ (NSString *)dateTimeStringFromDate:(NSDate *)dt;

/**
 * @return Returns the date according to @param s, if it has the following format:
 * "MM dd, yyyy"
 * Returns nil otherwise
 * @param s Date string
 */
+ (NSDate *)dateFromString:(NSString *)s;

/*
 * Returns formated date string
 */
+ (NSString *)formatDate:(NSDate *)dt withFormat:(DateFormat)df;

/**
 * @return Returns YES, if @param dt is Saturday or Sunday. Returns NO otherwise
 */
+ (BOOL)isWeekendDay:(NSDate *)dt;

/**
 * @return Returns the name of the week day according to @param dt
 */
+ (NSString *)weekDayFromDate:(NSDate *)dt;

/**
 * @return Returns the date corresponding to the day which is the first day of the week in which @param dt is
 */
+ (NSDate *)getWeekStartFromDate:(NSDate *)dt;

/**
 * @return Returns the date corresponding to the day which is the last day of the week in which @param dt is
 */
+ (NSDate *)getWeekEndFromDate:(NSDate *)dt;

/**
 * @return Returns the date corresponding to the @param weekday day of the week in which @param dt is
 */
+ (NSDate *)getWeekday:(NSInteger)weekday fromDate:(NSDate *)dt;

/**
 * If @param dt was more then 2 days ago, returns a string with the following pattern: "x days ago"
 * If @param st will be after more then 2 days, returns a string with the following pattern: "in x days"
 * Returns "Yesterday", "Today" or "Tomorrow", if @param dt is accordingly yesterday, today or tomorrow
 * @param dt Date without time component
 * @note This method should be used only when not considering time component of any date
 */
+ (NSString *)getDateRelated:(NSDate *)dt;

/// Returns relative date taking into account hours and minutes
+ (NSString *)getTimeRelated:(NSDate *)dt;

/**
 * @return Returns the differnece between @param d1 and @param d2 as the number of days
 */
//+ (NSInteger)dateDifferenceFrom:(NSDate *)d1 to:(NSDate *)d2;
+ (NSInteger)dateDifferenceFrom:(NSDate *)d1 to:(NSDate *)d2 excludeWeekends:(BOOL)excludeWeekends;

+ (NSInteger)getDaysCountSinceDate:(NSDate *)date;
+ (NSInteger)getDaysCountSince2000;
+ (NSDate *)dateFromTimestamp:(NSDecimalNumber *)ts;

/// @return Returns the date corresponding to the day which was @param n days ago
+ (NSDate *)getNthDateBeforeNow:(int)n;

/**
 * @return Returns the date according to @param str, if it has the following format:
 * "yyyy-MM-ddTHH:mm:ss:SSSZ"
 * Returns nil otherwise
 * @param s Date string
 */
+ (NSDate *)dateFromRESTAPI:(NSString *)str;

/**
 * @return Returns date string which represent @param dt in the following format:
 * "yyyy-MM-ddTHH:mm:ss:SSSZ"
 */
+ (NSString *)dateToRESTAPI:(NSDate *)dt;

/**
 * Removes time component form @param date
 * @return Returns a new date which doesn't have a time component
 */
+ (NSDate *)removeTimeComponent:(NSDate *)date;

/**
 * @return Returns YES if @param date1 differce from @param date2 no more then @param precision seconds
 */
+ (BOOL)date:(NSDate *)date1 equalsToDate:(NSDate *)date2 withPrecision:(double)precision;

/**
 * @return Returns a date after @param m months from today
 */
+ (NSDate *)dateAfterMonths:(NSInteger)m;

/**
 * @return Returns a date after @param w weeks from today
 */
+ (NSDate *)dateAfterWeeks:(NSInteger)w;

@end