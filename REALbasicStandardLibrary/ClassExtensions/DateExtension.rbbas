#tag Module
Protected Module DateExtension
	#tag Method, Flags = &h21
		Private Function Make_tm(d as Date=nil) As libc.tm
		  if d is nil then
		    d = new Date
		  end if
		  
		  #if targetMacOS or targetLinux
		    dim secondsSinceEpoch as Integer = CType(d.TotalSeconds - 3600.0*d.GMTOffset - UnixEpoch.TotalSeconds, Integer)
		    dim p as Ptr = libc.localtime(secondsSinceEpoch)
		    if p <> nil then
		      return p.tm
		    else
		      dim t as libc.tm
		      return t
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Max(paramArray d() as Date) As Date
		  return Max(d)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Max(d() as Date) As Date
		  #pragma disableBackgroundTasks
		  
		  if d = nil or UBound(d) = -1 then
		    return nil
		  end if
		  
		  dim maxDate as Date = d(0)
		  for i as Integer = 1 to UBound(d)
		    if (d(i) <> nil) and (d(i) > maxDate) then
		      maxDate = d(i)
		    end if
		  next
		  
		  return maxDate
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StringValue(extends d as Date, format as String) As String
		  dim buffer as new MemoryBlock(1024)
		  
		  dim timeptr as tm = Make_tm(d)
		  dim strftime_result as Integer = libc.strftime(buffer, buffer.Size, format, timeptr)
		  if strftime_result > 0 then
		    return DefineEncoding(buffer.CString(0), Encodings.SystemDefault)
		  else
		    return ""
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StringValue(extends d as Date, format as String, assigns value as String)
		  dim tm_value as tm
		  
		  dim p as Ptr = libc.strptime(value, format, tm_value)
		  if p <> nil then
		    d.TotalSeconds = unix_epoch_totalseconds + totalSecondsSinceUnixEpoch(tm_value) + SecondsInOneHour*d.GMTOffset
		  else
		    raise new UnsupportedFormatException
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TotalSecondsSinceUnixEpoch(tm_value as libc.tm) As Double
		  return libc.mktime(tm_value)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UnixEpoch() As Date
		  static totalseconds as Double = unix_epoch_totalseconds
		  
		  dim d as new Date
		  d.GMTOffset = 0.0
		  d.TotalSeconds = totalseconds
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function unix_epoch_totalseconds() As Double
		  dim t as Integer = 0
		  dim p as Ptr = libc.gmtime(t)
		  if p <> nil then
		    dim tm_value as libc.tm = p.tm(0)
		    
		    dim d as new Date(1900 + tm_value.tm_year, 1 + tm_value.tm_mon, tm_value.tm_mday)
		    d.GMTOffset = 0.0
		    d.Hour = tm_value.tm_hour
		    d.Minute = tm_value.tm_min
		    d.Second = tm_value.tm_sec
		    return d.TotalSeconds
		  else
		    return 0
		  end if
		End Function
	#tag EndMethod


	#tag Note, Name = C declarations
		
		size_t
		strftime(char *restrict s, size_t maxsize, const char *restrict format, const struct tm *restrict timeptr);
		
		#include <time.h>
		#include <xlocale.h>
		
		struct tm
		int    tm_sec   seconds [0,61]
		int    tm_min   minutes [0,59]
		int    tm_hour  hour [0,23]
		int    tm_mday  day of month [1,31]
		int    tm_mon   month of year [0,11]
		int    tm_year  years since 1900
		int    tm_wday  day of week [0,6] (Sunday = 0)
		int    tm_yday  day of year [0,365]
		int    tm_isdst daylight savings flag
		
		
		BSD
		struct tm {
		int    tm_sec;        /* seconds after the minute [0-60] */
		int    tm_min;        /* minutes after the hour [0-59] */
		int    tm_hour;    /* hours since midnight [0-23] */
		int    tm_mday;    /* day of the month [1-31] */
		int    tm_mon;        /* months since January [0-11] */
		int    tm_year;    /* years since 1900 */
		int    tm_wday;    /* days since Sunday [0-6] */
		int    tm_yday;    /* days since January 1 [0-365] */
		int    tm_isdst;    /* Daylight Savings Time flag */
		long    tm_gmtoff;    /* offset from CUT in seconds */
		char    *tm_zone;    /* timezone abbreviation */
		};
	#tag EndNote

	#tag Note, Name = Common Date Format Strings
		
		
		"%FT%T%z" ISO 8601 extended -- used to parse a datetime that looks like '2009-10-21T16:17:05-0400'.
		
		
		"%a, %d %b %Y %H:%M:%S %z"  RFC 2822 -- parses datetimes like 'Tue, 20 Oct 2009 19:54:47 -0400'
	#tag EndNote

	#tag Note, Name = StringValue
		The format argument should be a string built using codes from the list below.  Source: http://www.opengroup.org/onlinepubs/007908799/xsh/strftime.html .
		
		
		%a
		is replaced by the locale's abbreviated weekday name.
		%A
		is replaced by the locale's full weekday name.
		%b
		is replaced by the locale's abbreviated month name.
		%B
		is replaced by the locale's full month name.
		%c
		is replaced by the locale's appropriate date and time representation.
		%C
		is replaced by the century number (the year divided by 100 and truncated to an integer) as a decimal number [00-99].
		%d
		is replaced by the day of the month as a decimal number [01,31].
		%D
		same as %m/%d/%y.
		%e
		is replaced by the day of the month as a decimal number [1,31]; a single digit is preceded by a space.
		%h
		same as %b.
		%H
		is replaced by the hour (24-hour clock) as a decimal number [00,23].
		%I
		is replaced by the hour (12-hour clock) as a decimal number [01,12].
		%j
		is replaced by the day of the year as a decimal number [001,366].
		%m
		is replaced by the month as a decimal number [01,12].
		%M
		is replaced by the minute as a decimal number [00,59].
		%n
		is replaced by a newline character.
		%p
		is replaced by the locale's equivalent of either a.m. or p.m.
		%r
		is replaced by the time in a.m. and p.m. notation; in the POSIX locale this is equivalent to %I:%M:%S %p.
		%R
		is replaced by the time in 24 hour notation (%H:%M).
		%S
		is replaced by the second as a decimal number [00,61].
		%t
		is replaced by a tab character.
		%T
		is replaced by the time (%H:%M:%S).
		%u
		is replaced by the weekday as a decimal number [1,7], with 1 representing Monday.
		%U
		is replaced by the week number of the year (Sunday as the first day of the week) as a decimal number [00,53].
		%V
		is replaced by the week number of the year (Monday as the first day of the week) as a decimal number [01,53]. If the week containing 1 January has four or more days in the new year, then it is considered week 1. Otherwise, it is the last week of the previous year, and the next week is week 1.
		%w
		is replaced by the weekday as a decimal number [0,6], with 0 representing Sunday.
		%W
		is replaced by the week number of the year (Monday as the first day of the week) as a decimal number [00,53]. All days in a new year preceding the first Monday are considered to be in week 0.
		%x
		is replaced by the locale's appropriate date representation.
		%X
		is replaced by the locale's appropriate time representation.
		%y
		is replaced by the year without century as a decimal number [00,99].
		%Y
		is replaced by the year with century as a decimal number.
		%Z
		is replaced by the timezone name or abbreviation, or by no bytes if no timezone information exists.
		%%
		is replaced by %.
		If a conversion specification does not correspond to any of the above, the behaviour is undefined.
		
		Modified Conversion Specifiers
		
		Some conversion specifiers can be modified by the E or O modifier characters to indicate that an alternative format or specification should be used rather than the one normally used by the unmodified conversion specifier. If the alternative format or specification does not exist for the current locale, (see ERA in the XBD specification, Section 5.3.5) the behaviour will be as if the unmodified conversion specification were used.
		%Ec
		is replaced by the locale's alternative appropriate date and time representation.
		%EC
		is replaced by the name of the base year (period) in the locale's alternative representation.
		%Ex
		is replaced by the locale's alternative date representation.
		%EX
		is replaced by the locale' alternative time representation.
		%Ey
		is replaced by the offset from %EC (year only) in the locale's alternative representation.
		%EY
		is replaced by the full alternative year representation.
		%Od
		is replaced by the day of the month, using the locale's alternative numeric symbols, filled as needed with leading zeros if there is any alternative symbol for zero, otherwise with leading spaces.
		%Oe
		is replaced by the day of month, using the locale's alternative numeric symbols, filled as needed with leading spaces.
		%OH
		is replaced by the hour (24-hour clock) using the locale's alternative numeric symbols.
		%OI
		is replaced by the hour (12-hour clock) using the locale's alternative numeric symbols.
		%Om
		is replaced by the month using the locale's alternative numeric symbols.
		%OM
		is replaced by the minutes using the locale's alternative numeric symbols.
		%OS
		is replaced by the seconds using the locale's alternative numeric symbols.
		%Ou
		is replaced by the weekday as a number in the locale's alternative representation (Monday=1).
		%OU
		is replaced by the week number of the year (Sunday as the first day of the week, rules corresponding to %U) using the locale's alternative numeric symbols.
		%OV
		is replaced by the week number of the year (Monday as the first day of the week, rules corresponding to %V) using the locale's alternative numeric symbols.
		%Ow
		is replaced by the number of the weekday (Sunday=0) using the locale's alternative numeric symbols.
		%OW
		is replaced by the week number of the year (Monday as the first day of the week) using the locale's alternative numeric symbols.
		%Oy
		is replaced by the year (offset from %C) using the locale's alternative numeric symbols.
	#tag EndNote


	#tag Constant, Name = SecondsInOneHour, Type = Double, Dynamic = False, Default = \"3600.0", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
