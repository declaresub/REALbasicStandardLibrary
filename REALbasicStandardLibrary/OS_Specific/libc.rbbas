#tag Module
Protected Module libc
	#tag ExternalMethod, Flags = &h1
		Protected Declare Function basename Lib libc (path as CString) As CString
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function dirname Lib libc (path as CString) As CString
	#tag EndExternalMethod


	#tag Constant, Name = libc, Type = String, Dynamic = False, Default = \"", Scope = Protected
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"/usr/lib/libc.dylib"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"libc.so"
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"Msvcrt.dll"
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
