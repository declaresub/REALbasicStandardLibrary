#tag Module
Protected Module IDECommunicator
	#tag Method, Flags = &h1
		Protected Function FindIPCPath() As String
		  // Find a path for our temp file.
		  Dim parent As FolderItem
		  
		  parent = GetFolderItem( "/tmp", FolderItem.PathTypeShell  )
		  
		  if parent = nil or not parent.exists or not parent.IsWriteable then
		    parent = GetFolderItem( "/var/tmp", FolderItem.PathTypeShell  )
		  end if
		  
		  if parent = nil or not parent.exists or not parent.IsWriteable then
		    parent = SpecialFolder.Temporary
		  end if
		  
		  if parent = nil or not parent.exists or not parent.IsWriteable then
		    parent = SpecialFolder.Home
		  end if
		  
		  return parent.Child("REALStudioIDE").ShellPath
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ReportError(errorCode As Integer)
		  // A socket error has occurred.  If you're using this module
		  // in your own code, you'll probably want to replace this
		  // with some error reporting mechanism that fits into your app.
		  
		  #if not TargetHasGUI
		    stderr.WriteLine "Socket error: " + str(errorCode)
		  #else
		    #pragma unused errorCode
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SendScript(sourceCode As String)
		  // Send the given source to the IDE.
		  
		  Dim sock As New IPCSocket
		  sock.Path = FindIPCPath
		  sock.Connect
		  sock.Write sourceCode
		  while sock.BytesLeftToSend > 0
		    sock.Poll
		    if sock.LastErrorCode <> 0 then
		      ReportError sock.LastErrorCode
		      return
		    end if
		  wend
		  
		  sock.Close
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = About This Module
		
		This module provides code for sending IDE Scripting commands to the
		REALbasic IDE.  Feel free to use this in your own projects (without any
		warranty, express or implied).
		
		To use, just call IDECommunicator.SendScript and pass in the text of the
		script you want the IDE to execute.  If you're curious where it's looking
		for a communications path with the IDE, you can get that information from
		IDECommunicator.FindIPCPath.
	#tag EndNote


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
