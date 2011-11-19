#tag Module
Protected Module StringExtension
	#tag Method, Flags = &h0
		Function IsIn(extends s as String, L() as String) As Boolean
		  return L.IndexOf(s) > -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsNotIn(extends s as String, L() as String) As Boolean
		  return L.IndexOf(s) = -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NormalizedForm(s as String, form as Integer) As String
		  if s.Encoding = nil then
		    dim e as new UnsupportedFormatException
		    e.Message = "Cannot normalize a String with nil encoding."
		    raise e
		  end if
		  
		  if s = "" then
		    return s
		  end if
		  
		  #if targetMacOS
		    soft declare function CFStringCreateMutable lib CarbonFramework (alloc as Ptr, maxLength as Integer) as Ptr
		    soft declare sub CFStringAppendCString lib CarbonFramework (theString as Ptr, cStr as CString, encoding as Integer)
		    soft declare sub  CFStringNormalize lib CarbonFramework (theString as Ptr, theForm as Integer)
		    soft declare function CFStringGetLength lib CarbonFramework (cf as Ptr) as Integer
		    soft declare function CFStringGetMaximumSizeForEncoding lib CarbonFramework (length as Integer, enc as Integer) as Integer
		    soft declare function CFStringGetCString lib CarbonFramework (theString as Ptr, buffer as Ptr, bufferSize as Integer, enc as Integer) as Boolean
		    
		    dim code as Integer = s.Encoding.code
		    dim p as Ptr = CFStringCreateMutable(nil, 0)
		    if p = nil then
		      return ""
		    end if
		    CFStringAppendCString(p, s, Encoding(s).code)
		    CFStringNormalize(p, form)
		    
		    dim buffer as new MemoryBlock(1 + CFStringGetMaximumSizeForEncoding(CFStringGetLength(p), code))
		    dim normalizedString as String
		    if CFStringGetCString(p, buffer, buffer.Size, code) then
		      normalizedString = DefineEncoding(buffer.CString(0), s.Encoding)
		    else
		      normalizedString = ""
		    end if
		    macos.CFRelease(p)
		  #endif
		  
		  #if targetWin32
		    dim normalizedString as String
		    
		    dim estimatedBufferSize as Integer = NormalizeString(form, s, -1, nil, 0)
		    if estimatedBufferSize > 0 then
		      do
		        const sizeof_WCHAR = 2
		        dim buffer as new MemoryBlock(1 + estimatedBufferSize * sizeof_WCHAR)
		        const AssumeNullTerminatedInput = -1
		        dim newLength as Integer = NormalizeString(form, s, AssumeNullTerminatedInput, buffer, buffer.Size)
		        if newLength > 0 then
		          normalizedString = ConvertEncoding(buffer.WString(0), s.Encoding)
		          exit
		        else
		          //check for buffer size.
		          dim err as Integer = Win32Error.GetError
		          if err = Win32Error.ERROR_INSUFFICIENT_BUFFER then
		            //try again with bigger buffer
		            estimatedBufferSize = estimatedBufferSize * 2
		          elseIf err = Win32Error.ERROR_SUCCESS then
		            //does this mean that no normalizing was needed?
		            exit
		          else
		            raise new Win32Error(err)
		          end if
		        end if
		      loop
		    else
		      raise new Win32Error(Win32Error.GetError)
		    end if
		    
		    return normalizedString
		  #endif
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormalizedFormC(extends s as String) As String
		  const kCFStringNormalizationFormC = 2
		  return NormalizedForm(s, kCFStringNormalizationFormC)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormalizedFormD(extends s as String) As String
		  const kCFStringNormalizationFormD = 0
		  return NormalizedForm(s, kCFStringNormalizationFormD)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormalizedFormKC(extends s as String) As String
		  const kCFStringNormalizationFormKC = 3
		  return NormalizedForm(s, kCFStringNormalizationFormKC)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormalizedFormKD(extends s as String) As String
		  const kCFStringNormalizationFormKD = 1
		  return NormalizedForm(s, kCFStringNormalizationFormKD)
		End Function
	#tag EndMethod


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
