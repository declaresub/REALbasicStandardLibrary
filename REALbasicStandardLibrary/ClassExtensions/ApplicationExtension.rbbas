#tag Module
Protected Module ApplicationExtension
	#tag Method, Flags = &h21
		Private Function GetProcessID() As Integer
		  #if targetMacOS
		    //returns the BSD pid, not the Mac OS PSN.
		    
		    return libc.getpid()
		  #endif
		  
		  #if targetWin32
		    return win32.GetCurrentProcessId
		  #endif
		  
		  #if targetLinux
		    return libc.getpid()
		  #endif
		  
		  // from man page for getpid:
		  // ERRORS
		  // The getpid() and getppid() functions are always successful, and no return
		  // value is reserved to indicate an error.
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PID(extends theApp as Application) As Integer
		  #pragma unused theApp
		  
		  //we assume that the PID won't change during the lifetime of execution.
		  
		  static the_pid as Integer = GetProcessID
		  return the_pid
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
