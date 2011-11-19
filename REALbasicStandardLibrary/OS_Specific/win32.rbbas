#tag Module
Protected Module win32
	#tag ExternalMethod, Flags = &h1
		Protected Declare Function GetCurrentProcessId Lib Kernel32 () As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function NormalizeString Lib Normaliz (NormForm as Integer, lpSrcString as WString, cwSrcLength as Integer, lpDstString as Ptr, cwDstLength as Integer) As Integer
	#tag EndExternalMethod


	#tag Constant, Name = Kernel32, Type = String, Dynamic = False, Default = \"Kernel32.dll", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Normaliz, Type = String, Dynamic = False, Default = \"Normaliz.dll", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Rpcrt4, Type = String, Dynamic = False, Default = \"Rpcrt4.dll", Scope = Protected
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
