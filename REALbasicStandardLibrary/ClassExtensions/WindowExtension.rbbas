#tag Module
Protected Module WindowExtension
	#tag Method, Flags = &h0
		Function ContainerControls(extends w as Window) As ContainerControl()
		  #pragma disableBackgroundTasks
		  
		  dim theList() as ContainerControl
		  dim o as Runtime.ObjectIterator = Runtime.IterateObjects
		  while o.MoveNext
		    if o.Current isA ContainerControl and ContainerControl(o.Current).Window is w then
		      theList.Append ContainerControl(o.Current)
		    end if
		  wend
		  return theList
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Controls(extends w as Window) As Control()
		  #pragma disableBackgroundTasks
		  
		  dim theList() as Control
		  dim lastIndex as Integer = w.ControlCount - 1
		  for i as Integer = 0 to lastIndex
		    dim c as Control = w.Control(i)
		    if c <> nil then
		      theList.Append c
		    end if
		  next
		  return theList
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
