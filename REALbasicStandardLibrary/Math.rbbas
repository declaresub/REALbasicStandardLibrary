#tag Module
Protected Module Math
	#tag ExternalMethod, Flags = &h1
		Protected Declare Function acos Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function acosh Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function asin Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function asinh Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function atan Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function atan2 Lib libc (y as Double, x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function atanh Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function cos Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function cosh Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function erf Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function exp Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function exp2 Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function expm1 Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function fabs Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function frexp Lib libc (x as Double, ByRef pexp as Integer) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function ilogb Lib libc (x as Double) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function ldexp Lib libc (val as Double, exponent as integer) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function log Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function log10 Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function log1p Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function log2 Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function logb Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function modf Lib libc (x as Double, ByRef i as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function nan Lib libc (tag as CString) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function scalbn Lib libc (x as Double, exponent as Integer) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function sin Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function sinh Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function tan Lib libc (x as Double) As Double
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function tanh Lib libc (x as Double) As Double
	#tag EndExternalMethod


	#tag Constant, Name = e, Type = Double, Dynamic = False, Default = \"2.71828182845904523536028747135266250", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = libc, Type = String, Dynamic = False, Default = \"", Scope = Private
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"/usr/lib/libc.dylib"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"libc.so"
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"Msvcrt.dll"
	#tag EndConstant

	#tag Constant, Name = ln2, Type = Double, Dynamic = False, Default = \"0.693147180559945309417232121458176568", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = log10e, Type = Double, Dynamic = False, Default = \"0.434294481903251827651128918916605082", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = log2e, Type = Double, Dynamic = False, Default = \"1.44269504088896340735992468100189214", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Pi, Type = Double, Dynamic = False, Default = \"3.14159265358979323846264338327950288", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = sqrt2, Type = Double, Dynamic = False, Default = \"1.41421356237309504880168872420969808", Scope = Protected
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
