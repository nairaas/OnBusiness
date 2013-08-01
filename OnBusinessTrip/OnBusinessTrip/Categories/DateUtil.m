//
//  DateUtil.m
//  AtTask
//
//  Created by Mikayel Aghasyan on 8/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DateUtil.h"
#import "Constants.h"
//#import "CustomerPrefBean.h"

@interface DateUtil (private)

+ (NSDateFormatter *)createDateFormatter;
+ (NSDateFormatter *)createDateTimeFormatter;
+ (NSDateFormatter *)createDateFormatterREST;
+ (NSDateFormatter *)createDateTimeFormatterREST;

@end

@implementation DateUtil

+ (NSDateFormatter *)createDateFormatter {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSDateFormatter *formatter = [threadDictionary valueForKey:@"dateFormatter"];
	if (!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setTimeStyle:NSDateFormatterNoStyle];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[threadDictionary setValue:formatter forKey:@"dateFormatter"];
	}
	return formatter;
}

+ (NSDateFormatter *)createDateTimeFormatter {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSDateFormatter *formatter = [threadDictionary valueForKey:@"dateTimeFormatter"];
	if (!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MMM d, yyyy HH:mm a"];
		[threadDictionary setValue:formatter forKey:@"dateTimeFormatter"];
	}
	return formatter;
}

+ (NSDateFormatter *)createDateFormatterREST {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSDateFormatter *formatter = [threadDictionary valueForKey:@"dateFormatterREST"];
	if (!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setLenient:YES];
		[formatter setDateFormat:@"yyyy-MM-dd"];
		[threadDictionary setValue:formatter forKey:@"dateFormatterREST"];
	}
	return formatter;
}

+ (NSDateFormatter *)createDateTimeFormatterREST {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSDateFormatter *formatter = [threadDictionary valueForKey:@"dateTimeFormatterREST"];
	if (!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setLenient:YES];
		[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss:SSSZ"];
		[threadDictionary setValue:formatter forKey:@"dateTimeFormatterREST"];
	}
	return formatter;
}

+ (NSCalendar *)createGregorianCalendar {
	NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
	NSCalendar *calendar = [threadDictionary valueForKey:@"gregorianCalendar"];
	if (!calendar) {
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		[threadDictionary setValue:calendar forKey:@"gregorianCalendar"];
	}
	return calendar;
}

#pragma mark -

+ (NSString *)stringFromDate:(NSDate *)dt {
	if (nil == dt) {
		return @"";
	}
	return [[DateUtil createDateFormatter] stringFromDate:dt];
}

+ (NSString *)shortStringFromDate:(NSDate *)dt fullMonth:(BOOL)fullMonth {
	if (nil == dt) {
		return @"";
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	if (fullMonth) {
		[formatter setDateFormat:@"MMMM dd"];
	} else {
		[formatter setDateFormat:@"MMM dd"];
	}
	NSString *str = [formatter stringFromDate:dt];
	return str;
}

+ (NSString *)dateTimeStringFromDate:(NSDate *)dt {
	return [[DateUtil createDateTimeFormatter] stringFromDate:dt];
}

+ (NSDate *)dateFromString:(NSString *)s {
	return [[DateUtil createDateFormatter] dateFromString:s];
}

+ (NSString *)formatDate:(NSDate *)dt withFormat:(DateFormat)df {
	NSString * __autoreleasing str = @"";
	if (dt) {
		str = [DateUtil stringFromDate:dt];
		switch (df) {
			case DateFormatMMMDDYYYY:
				break;
			case DateFormatMMMDD: {
				NSScanner *scanner = [[NSScanner alloc] initWithString:str];
				[scanner scanUpToString:@"," intoString:&str];
				break;
			}
			default:
				break;
		}
	}
	return str;
}

+ (BOOL)isWeekendDay:(NSDate *)dt {
	NSCalendar *calendar = [DateUtil createGregorianCalendar];
	NSDateComponents *comps = [calendar components:(NSWeekdayCalendarUnit) fromDate:dt];
	NSInteger weekday = [comps weekday];
	return (weekday == 1 || weekday == 7);
}

+ (NSString *)weekDayFromDate:(NSDate *)dt {
	if (dt == nil) {
		return @"";
	}
	NSCalendar *calendar = [DateUtil createGregorianCalendar];
	NSDateComponents *comps = [calendar components:(NSWeekdayCalendarUnit) fromDate:dt];
	return [[[DateUtil createDateFormatter] weekdaySymbols] objectAtIndex:[comps weekday]-1];
}

+ (NSDate *)getWeekStartFromDate:(NSDate *)dt {
	return [DateUtil getWeekday:1 fromDate:dt];
}

+ (NSDate *)getWeekEndFromDate:(NSDate *)dt {
	return [DateUtil getWeekday:7 fromDate:dt];
}

+ (NSDate *)getWeekday:(NSInteger)weekday fromDate:(NSDate *)dt {
	NSCalendar *gregorian = [DateUtil createGregorianCalendar];
	// Get the weekday component of the given date
	NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:dt];
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 */
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay:(weekday - [weekdayComponents weekday])];
	NSDate *result = [gregorian dateByAddingComponents:componentsToSubtract toDate:dt options:0];
	/*
	 Optional step:
	 result now has the same hour, minute, and second as the original date (today).
	 To normalize to midnight, extract the year, month, and day components and create a new date from those components.
	 */
	NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:result];
	result = [gregorian dateFromComponents:components];
	return result;
}

+ (NSString *)getDateRelated:(NSDate *)dt {
	if (dt == nil) {
		return @"";
	}
	NSDate *dtNow = [NSDate date];
	NSCalendar *calendar = [DateUtil createGregorianCalendar];
	NSDateComponents *comps = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dtNow];
	dtNow = [calendar dateFromComponents:comps];

	comps = [calendar components:NSDayCalendarUnit fromDate:dtNow toDate:dt options:0];
	int days = [comps day];

	if (days <= -2) {
		return [NSString stringWithFormat:NSLocalizedString(@"daysago.plural", @"x days ago"), -days, nil];
	} else if (days >= 2) {
		return [NSString stringWithFormat:NSLocalizedString(@"indays.plural", @"in x days"), days, nil];
	} else if (days == -1) {
		return NSLocalizedString(@"yesterday", @"Yesterday");
	} else if (days == 1) {
		return NSLocalizedString(@"tomorrow", @"Tomorrow");
	} else {
		return NSLocalizedString(@"today", @"Today");
	}
	return nil;
}

+ (NSString *)timeRelatedDateIncludingMonth:(NSDate *)dt {
	NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
	[dateTimeFormatter setPMSymbol:@"pm"];
	[dateTimeFormatter setAMSymbol:@"am"];
	NSString *format = nil;
	NSString *date = nil;
	
	format = @"MMMM dd";
	[dateTimeFormatter setDateFormat:format];
	date = [dateTimeFormatter stringFromDate:dt];
	
	format = @"h:mm a";
	[dateTimeFormatter setDateFormat:format];
	return [NSString stringWithFormat:NSLocalizedString(@"at", @"February 17 at 4:24 PM"), date, [dateTimeFormatter stringFromDate:dt] , nil];
}

+ (NSString *)timeRelatedDate:(NSDate *)dt withDays:(NSInteger)days {
	NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
	[dateTimeFormatter setPMSymbol:@"pm"];
	[dateTimeFormatter setAMSymbol:@"am"];
	NSString *format = nil;
	NSString *date = nil;
	if (abs(days) == 1) {
		date = (days > 0) ? NSLocalizedString(@"tomorrow", @"Tomorrow") : NSLocalizedString(@"yesterday", @"Yesterday");
	} else {
		format = @"MMMM dd";
		[dateTimeFormatter setDateFormat:format];
		date = [dateTimeFormatter stringFromDate:dt];
	}
	format = @"h:mm a";
	[dateTimeFormatter setDateFormat:format];
	return [NSString stringWithFormat:NSLocalizedString(@"at", @"February 17 at 4:24 PM"), date, [dateTimeFormatter stringFromDate:dt] , nil];
}

+ (NSString *)timeRelatedDate:(NSDate *)dt withHours:(NSInteger)hours {
	if (abs(hours) == 1) {
		return (hours > 0) ? NSLocalizedString(@"inonehour", @"in 1 hour") : NSLocalizedString(@"onehourago", @"1 hour ago");
	}
	return [NSString stringWithFormat:((hours > 0) ? NSLocalizedString(@"inhours.plural", @"in x hours") : NSLocalizedString(@"hoursago.plural", @"x hours ago")), abs(hours), nil];
}

+ (NSString *)timeRelatedDate:(NSDate *)dt withMinutes:(NSInteger)minutes {
	if (minutes != 0) {
		if (abs(minutes) == 1) {
			return (minutes > 0) ? NSLocalizedString(@"inoneminute", @"in 1 minute") : NSLocalizedString(@"oneminuteago", @"1 minute ago");
		}
		return [NSString stringWithFormat:((minutes > 0) ? NSLocalizedString(@"inminutes.plural", @"in x minutes") : NSLocalizedString(@"minutesago.plural", @"x minutes ago")), abs(minutes), nil];
	}
	return NSLocalizedString(@"justnow", @"Just now");
}

+ (NSString *)getTimeRelated:(NSDate *)dt {
	if (dt == nil) {
		return @"";
	}
	NSDate *dtNow = [NSDate date];
	if ([dt timeIntervalSinceDate:dtNow] == 0) {
		return NSLocalizedString(@"justnow", @"Just now");
	}
	NSCalendar *calendar = [DateUtil createGregorianCalendar];
	NSDateComponents *comps = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | 
													NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) 
										  fromDate:dtNow toDate:dt options:0];
	int era = [comps era];
	int years = [comps year];
	int months = [comps month];
	int days = [comps day];
	int hours = [comps hour];
	int minutes = [comps minute];
	if (era != 0 || years != 0 || months != 0) {
		return [DateUtil timeRelatedDateIncludingMonth:dt];
	} 
	if (days != 0) {
		return [DateUtil timeRelatedDate:dt withDays:days];
	}
	if (hours != 0) {
		return [DateUtil timeRelatedDate:dt withHours:hours];
	}
	return [DateUtil timeRelatedDate:dt withMinutes:minutes];
}

+ (NSInteger)dateDifferenceFrom:(NSDate *)d1 to:(NSDate *)d2 excludeWeekends:(BOOL)excludeWeekends {
	if (d1 == nil || d2 == nil) {
		return 0;
	}
	NSCalendar *calendar = [DateUtil createGregorianCalendar];
	NSUInteger comps = (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
	if (excludeWeekends) {
		comps |= NSWeekdayCalendarUnit;
	}
//	NSDateComponents *comps = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:d1];
	NSDateComponents *startDateComps = [calendar components:comps fromDate:d1];
	NSDate *d11 = [calendar dateFromComponents:startDateComps];
	NSDateComponents *dateComps = [calendar components:comps fromDate:d2];
	NSDate *d22 = [calendar dateFromComponents:dateComps];
	dateComps = [calendar components:NSDayCalendarUnit fromDate:d11 toDate:d22 options:0];
	NSInteger count = [dateComps day];
	if (excludeWeekends) {
		NSInteger weekday = [startDateComps weekday];
		weekday = (weekday == 1) ? 8 : weekday;
		NSInteger remnant = ((count % 7) + weekday);
		count -= (count / 7) * 2 + (remnant >= 8 ? ((weekday < 8) ? 2 : 1) : (remnant == 7 ? 1 : 0));
	}
	return count;
}

/*
+ (NSInteger)dateDifferenceExcludingWeekendsFrom:(NSDate *)d1 to:(NSDate *)d2 {
	if (d1 == nil || d2 == nil) {
		return 0;
	}
	NSCalendar *calendar = [DateUtil createGregorianCalendar];
	NSDateComponents *comps = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:d1];
	NSDate *d11 = [calendar dateFromComponents:comps];
	comps = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:d2];
	NSDate *d22 = [calendar dateFromComponents:comps];
	comps = [calendar components:NSDayCalendarUnit fromDate:d11 toDate:d22 options:0];
	return [comps day];
}*/

+ (NSInteger)getDaysCountSinceDate:(NSDate *)date {
	NSCalendar *c = [DateUtil createGregorianCalendar];
	NSDateComponents *comps = [c components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
	[comps setMonth:comps.month - 1];
	NSDate *dt = [c dateFromComponents:comps];
	comps = [c components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
	NSDate *n = [c dateFromComponents:comps];	
	return [n timeIntervalSinceDate:dt] / (double)ONE_DAY_TIME_INETRVAL + 1;
}

+ (NSInteger)getDaysCountSince2000 {
	NSDate *n = [NSDate date];
	NSTimeInterval diff = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:n];
	NSDateComponents *c = [[NSDateComponents alloc] init];
	[c setYear:2000];
	[c setMonth:1];
	[c setDay:1];
	[c setSecond:diff];
	NSCalendar *calendar = [DateUtil createGregorianCalendar];
	NSDate *d = [calendar dateFromComponents:c];
	return [n timeIntervalSinceDate:d] / ONE_DAY_TIME_INETRVAL;
}

+ (NSDate *)dateFromTimestamp:(NSDecimalNumber *)ts {
	NSDate *dt = [NSDate dateWithTimeIntervalSince1970:([ts longLongValue] / 1000)];
	return dt;
}

+ (NSDate *)getNthDateBeforeNow:(int) n {
	const double x = -ONE_DAY_TIME_INETRVAL * n;
	return [NSDate dateWithTimeIntervalSinceNow:x];
}

+ (NSDate *)dateFromRESTAPI:(NSString *)str {
	if (![str isKindOfClass:[NSString class]]) {
		return nil;
	}
	NSDate *dt = [[DateUtil createDateTimeFormatterREST] dateFromString:str];
	if (!dt) {
		dt = [[DateUtil createDateFormatterREST] dateFromString:str];
	}
	return dt;
}

+ (NSString *)dateToRESTAPI:(NSDate *)dt {
	NSString *str = [[DateUtil createDateTimeFormatterREST] stringFromDate:dt];
	if (!str) {
		str = [[DateUtil createDateFormatterREST] stringFromDate:dt];
	}
	return str;
}

+ (NSDate *)removeTimeComponent:(NSDate *)date {
	if (!date || [date isKindOfClass:[NSNull class]]) {
		return nil;
	}
	NSCalendar *gregorian = [DateUtil createGregorianCalendar];
	NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
	NSDate *dateWithoutTime = [gregorian dateFromComponents:components];
	return dateWithoutTime;
}

+ (BOOL)date:(NSDate *)date1 equalsToDate:(NSDate *)date2 withPrecision:(double)precision {
	NSTimeInterval t1 = [date1 timeIntervalSince1970];
	NSTimeInterval t2 = [date2 timeIntervalSince1970];
	return (fabs(t1 - t2) < precision);
}

+ (NSDate *)dateAfterMonths:(NSInteger)m {
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	components.month = m;
	return [gregorian dateByAddingComponents:components toDate:today options:0];
}

+ (NSDate *)dateAfterWeeks:(NSInteger)w {
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	components.week = w;
	return [gregorian dateByAddingComponents:components toDate:today options:0];
}

@end