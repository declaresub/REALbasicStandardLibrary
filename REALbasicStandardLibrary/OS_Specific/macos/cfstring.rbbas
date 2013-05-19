#tag Module
Protected Module CFString
	#tag ExternalMethod, Flags = &h1
		Protected Declare Sub AppendCString Lib MacOS.CF.framework (theString as Ptr, cStr as CString, encoding as Integer)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function CreateMutable Lib MacOS.CF.framework Alias "CFStringCreateMutable" (alloc as Ptr, maxLength as Integer) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function GetBytes Lib MacOS.CF.framework Alias "CFStringGetBytes" (theString as Ptr, range as macos . cf . range, encoding as UInt32, lossByte as UInt8, isExternalRepresentation as Boolean, buffer as Ptr, maxBufLen as Integer, ByRef usedBufLen as Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function GetLength Lib MacOS.CF.framework Alias "CFStringGetLength" (theString as Ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Function GetMaximumSizeForEncoding Lib MacOS.CF.framework Alias "CFStringGetMaximumSizeForEncoding" (length as Integer, encoding as UInt32) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Declare Sub Normalize Lib MacOS.CF.framework (theString as Ptr, theForm as Integer)
	#tag EndExternalMethod

	#tag Method, Flags = &h1
		Protected Function RbString(p as Ptr) As String
		  #if targetMacOS
		    if p = nil then
		      return ""
		    end if
		    
		    dim rng as macos.cf.range
		    rng.location =0
		    rng.length = GetLength(p)
		    dim buffer as new MemoryBlock(GetMaximumSizeForEncoding(rng.length, EncodingUTF8))
		    dim usedBufLen as Integer
		    dim bytesConverted as Integer = GetBytes(p, rng, EncodingUTF8, 0, false, buffer, buffer.Size, usedBufLen)
		    return DefineEncoding(buffer.StringValue(0, usedBufLen), Encodings.UTF8)
		  #endif
		  
		  
		End Function
	#tag EndMethod


	#tag Constant, Name = EncodingUTF8, Type = Double, Dynamic = False, Default = \"&h08000100", Scope = Protected
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
