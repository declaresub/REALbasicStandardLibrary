#tag Module
Protected Module CoreFoundation
	#tag ExternalMethod, Flags = &h1
		Protected Declare Sub Release Lib framework Alias "CFRelease" (cf as Ptr)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Sub StringAppendCString Lib framework Alias "CFStringAppendCString" (theString as Ptr, cStr as CString, encoding as Integer)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function StringCreateMutable Lib framework Alias "CFStringCreateMutable" (alloc as Ptr, maxLength as Integer) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function StringGetLength Lib framework Alias "CFStringGetLength" (cf as Ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function StringGetMaximumSizeForEncoding Lib framework Alias "CFStringGetMaximumSizeForEncoding" (length as Integer, enc as Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Sub StringNormalize Lib framework Alias "CFStringNormalize" (theString as Ptr, theForm as Integer)
	#tag EndExternalMethod


	#tag Constant, Name = framework, Type = String, Dynamic = False, Default = \"CoreFoundation.framework", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = StringNormalizationFormC, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = StringNormalizationFormD, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = StringNormalizationFormKC, Type = Double, Dynamic = False, Default = \"3", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = StringNormalizationFormKD, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
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
