#tag Module
Protected Module Structures
	#tag Structure, Name = REG_TZI_FORMAT, Flags = &h1
		Bias as Integer
		  StandardBias as Integer
		  DaylightBias as Integer
		  StandardDate as SYSTEMTIME
		DaylightDate as SYSTEMTIME
	#tag EndStructure

	#tag Structure, Name = SYSTEMTIME, Flags = &h1
		wYear as UInt16
		  wMonth as UInt16
		  wDayOfWeek as UInt16
		  wDay as UInt16
		  wHour as UInt16
		  wMinute as UInt16
		  wSecond as UInt16
		wMilliseconds as UInt16
	#tag EndStructure

	#tag Structure, Name = TIME_ZONE_INFORMATION, Flags = &h1
		Bias as Integer
		  StandardName as WString*32
		  StandardDate as SYSTEMTIME
		  StandardBias as Integer
		  DaylightName as WString*32
		  DaylightDate as SYSTEMTIME
		DaylightBias as Integer
	#tag EndStructure


End Module
#tag EndModule
