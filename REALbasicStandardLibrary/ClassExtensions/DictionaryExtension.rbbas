#tag Module
Protected Module DictionaryExtension
	#tag Method, Flags = &h0
		Function Dict(items() as Pair) As Dictionary
		  #pragma disableBackgroundTasks
		  
		  dim d as new Dictionary
		  for each item as Pair in items
		    d.Value(item.Left) = item.Right
		  next
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Dict(paramArray items() as Pair) As Dictionary
		  return Dict(items)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Items(extends d as Dictionary) As Pair()
		  #pragma disableBackgroundTasks
		  
		  dim L() as Pair
		  for each key as Variant in d.Keys
		    L.Append key : d.Value(key)
		  next
		  return L
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
