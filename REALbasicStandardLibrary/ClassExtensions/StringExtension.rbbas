#tag Module
Protected Module StringExtension
	#tag Method, Flags = &h21
		Private Function find_symbol(functionName as String, libPath as String) As String
		  //find library name of unorm_normalize
		  dim s as new Shell
		  s.Execute("nm -o --dynamic " + libPath + " | grep -oE " + functionName + "[[:alnum:]_]*")
		  if s.ErrorCode = 0 then
		    return s.Result.Trim
		  else
		    return ""
		  end if
		End Function
	#tag EndMethod

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
		Private Function libicuuc() As Ptr
		  static handle as Ptr = open_lib(resolve_lib_name("libicuuc.so"))
		  return handle
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function load(function_name as String, libHandle as Ptr) As Ptr
		  
		  
		  declare function dlopen lib "libc.so" alias "__libc_dlopen_mode" (path as CString, flags as Integer) as Ptr
		  declare function dlsym lib "libc.so" alias "__libc_dlsym" (handle as Ptr, symbol as CString) as Ptr
		  declare sub dlclose lib "libc.so" alias "__libc_dlclose" (h as Ptr)
		  declare function dlerror lib "libc.so" alias "__libc_dl_error_tsd" () as Ptr
		  
		  dim f as Ptr = dlsym(libHandle, function_name)
		  dim err as Ptr = dlerror()
		  if err = nil then
		    return f
		  else
		    dlclose(libicuuc)
		    dim e as new FunctionNotFoundException
		    dim m as MemoryBlock = err
		    e.Message = m.CString(0)
		    raise e
		  end if
		  
		  
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
		    soft declare function CFStringGetMaximumSizeForEncoding lib CarbonFramework (length as Integer, enc as Integer) as Integer
		    soft declare function CFStringGetCString lib CarbonFramework (theString as Ptr, buffer as Ptr, bufferSize as Integer, enc as Integer) as Boolean
		    
		    dim p as Ptr = MacOS.CFString.CreateMutable(nil, 0)
		    if p = nil then
		      return ""
		    end if
		    dim normalizedString as String
		    try
		      MacOS.CFString.AppendCString(p, s, Encoding(s).code)
		      MacOS.CFString.Normalize(p, form)
		      return MacOS.CFString.RbString(p)
		      
		      dim buffer as new MemoryBlock(1 + CFStringGetMaximumSizeForEncoding(macos.cfstring.GetLength(p), Encoding(s).code))
		      if CFStringGetCString(p, buffer, buffer.Size, Encoding(s).code) then
		        normalizedString = DefineEncoding(buffer.CString(0), s.Encoding)
		      else
		        normalizedString = ""
		      end if
		    finally
		      macos.cf.Release(p)
		    end try
		    return normalizedString
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
		  
		  #if targetLinux
		    dim source as MemoryBlock = ConvertEncoding(s, Encodings.UTF16)
		    dim buffer as new MemoryBlock(source.Size)
		    dim status as Integer
		    do
		      dim bufferLength as Integer = unorm_normalize(source, Len(s), form, 0, buffer, buffer.Size, status)
		      if status <= U_ZERO_ERROR then
		        return ConvertEncoding(DefineEncoding(buffer.StringValue(0, 2*bufferLength), Encodings.UTF16), s.Encoding)
		      elseif status = U_BUFFER_OVERFLOW_ERROR then
		        //buffer was too small, so we increase size and try again.
		        buffer = new MemoryBlock(buffer.Size * 2)
		        
		      else
		        //raise exception of some sort?
		      end if
		    loop
		    
		  #endif
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormalizedFormC(extends s as String) As String
		  #if targetMacOS
		    const normalizationForm = macos.cf.StringNormalizationFormC
		  #endif
		  #if targetWin32
		    const normalizationForm = win32.NormalizationC
		  #endif
		  #if targetLinux
		    const UNORM_NFC = 4
		    const normalizationForm = UNORM_NFC
		  #endif
		  return NormalizedForm(s, normalizationForm)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormalizedFormD(extends s as String) As String
		  #if targetMacOS
		    const normalizationForm = macos.cf.StringNormalizationFormD
		  #endif
		  #if targetWin32
		    const normalizationForm = win32.NormalizationD
		  #endif
		  #if targetLinux
		    const UNORM_NFD = 2
		    const normalizationForm = UNORM_NFD
		  #endif
		  return NormalizedForm(s, normalizationForm)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormalizedFormKC(extends s as String) As String
		  #if targetMacOS
		    const normalizationForm = macos.cf.StringNormalizationFormKC
		  #endif
		  #if targetWin32
		    const normalizationForm = win32.NormalizationKC
		  #endif
		  #if targetLinux
		    const UNORM_NFKC = 5
		    const normalizationForm = UNORM_NFKC
		  #endif
		  return NormalizedForm(s, normalizationForm)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NormalizedFormKD(extends s as String) As String
		  #if targetMacOS
		    const normalizationForm = macos.cf.StringNormalizationFormKD
		  #endif
		  #if targetWin32
		    const normalizationForm = win32.NormalizationKD
		  #endif
		  #if targetLinux
		    const UNORM_NFKD = 3
		    const normalizationForm = UNORM_NFKD
		  #endif
		  return NormalizedForm(s, normalizationForm)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function open_lib(libpath as String) As Ptr
		  declare function dlopen lib "libc.so" alias "__libc_dlopen_mode" (path as CString, flags as Integer) as Ptr
		  declare function dlerror lib "libc.so" alias "__libc_dl_error_tsd" () as Ptr
		  
		  const RTLD_NOW = &h00002
		  dim handle as Ptr = dlopen(libpath, RTLD_NOW)
		  if handle <> nil then
		    return handle
		  else
		    dim e as new FunctionNotFoundException
		    dim p as Ptr = dlerror
		    if p <> nil then
		      dim m as MemoryBlock = p
		      e.Message = m.CString(0)
		    else
		      e.Message = "Unable to load '" + libpath + "'."
		    end if
		    raise e
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function resolve_lib_name(name as String) As String
		  dim s as new Shell
		  s.Execute("find /usr/lib -name """ + name + "*"" -type l | sort | head -1")
		  if s.ErrorCode = 0 then
		    return Trim(s.Result)
		  else
		    return ""
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function unorm_normalize(source as Ptr, sourceLength as Integer, mode as Integer, options as Integer, result as Ptr, resultLength as Integer, ByRef status as Integer) As Integer
		  static f as new _unorm_normalize(load("unorm_normalize", libicuuc))
		  return f.Invoke(source, sourceLength, mode, options, result, resultLength, status)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function u_errorName(code as Integer) As CString
		  static f as new _u_errorName(load("u_errorName", libicuuc))
		  return f.Invoke(code)
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h21
		Private Delegate Function _unorm_normalize(source as Ptr, sourceLength as Integer, mode as Integer, options as Integer, result as Ptr, resultLength as Integer, ByRef status as Integer) As Integer
	#tag EndDelegateDeclaration

	#tag DelegateDeclaration, Flags = &h21
		Private Delegate Function _u_errorName(code as Integer) As CString
	#tag EndDelegateDeclaration


	#tag Constant, Name = U_BUFFER_OVERFLOW_ERROR, Type = Double, Dynamic = False, Default = \"15", Scope = Private
	#tag EndConstant

	#tag Constant, Name = U_ZERO_ERROR, Type = Double, Dynamic = False, Default = \"0", Scope = Private
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
