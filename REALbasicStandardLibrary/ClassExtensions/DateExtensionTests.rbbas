#tag Class
Protected Class DateExtensionTests
	#tag Method, Flags = &h21
		Private Shared Sub Test_MaxDate_Nil()
		  dim now as new Date
		  dim L() as Date = Array(now, nil)
		  Max(L).ShouldEqual now
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_StringValue_Get()
		  dim d as new Date(2011, 08, 26, 12, 34, 56)
		  d.GMTOffset = -4
		  d.StringValue("%FT%T%z").ShouldEqual "2011-08-26T12:34:56-0400"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_StringValue_Set()
		  dim d as new Date
		  d.StringValue("%FT%T%z") = "2011-08-26T12:34:56-0400"
		  d.Year.ShouldEqual 2011
		  d.Month.ShouldEqual 8
		  d.Day.ShouldEqual 26
		  d.Hour.ShouldEqual 12
		  d.Minute.ShouldEqual 34
		  d.Second.ShouldEqual 56
		  d.GMTOffset.ShouldEqual -4.0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_UnixEpoch()
		  dim epoch as Date = UnixEpoch
		  epoch.Year.ShouldEqual 1970
		  epoch.Month.ShouldEqual 1
		  epoch.Day.ShouldEqual 1
		  epoch.Hour.ShouldEqual 0
		  epoch.Minute.ShouldEqual 0
		  epoch.Second.ShouldEqual 0
		  epoch.GMTOffset.ShouldEqual 0.0
		End Sub
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
End Class
#tag EndClass
