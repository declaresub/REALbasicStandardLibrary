#tag Class
Protected Class RealTest
	#tag Method, Flags = &h0
		Sub Constructor(test as Introspection.MethodInfo)
		  #pragma nilObjectChecking false
		  test.ShouldNotBe nil
		  #pragma nilObjectChecking true
		  test.IsShared.ShouldEqual true
		  
		  me.MethodInfo = test
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Execute()
		  self.MethodInfo.Invoke nil
		  
		  
		exception e as RuntimeException
		  if e isA EndException or e isA ThreadEndException then
		    #pragma breakOnExceptions off
		    raise e
		  end if
		  
		  if  (e isA RealTestFailure) then
		    #pragma breakOnExceptions off
		    raise e
		  else
		    //convert to a RealTestFailure
		    dim failure as new RealTestFailure
		    failure.actualValue = Introspection.GetType(e).FullName
		    #pragma breakOnExceptions off
		    raise failure
		  end if
		  
		  
		exception testfailure as RealTestFailure
		  testfailure.TestName = me.TestName
		  #pragma breakOnExceptions off
		  raise testfailure
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function MethodName(s as String, fieldcount as Integer = 1) As String
		  const separator = "."
		  
		  dim names() as String = Split(s, separator)
		  dim thename() as String
		  for i as Integer = UBound(names) - fieldcount to UBound(names)
		    thename.Append names(i)
		  next
		  return Join(thename, separator)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub RaiseNilObjectException()
		  //converts raise into a method
		  
		  #pragma breakOnExceptions off
		  
		  raise new NilObjectException
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub RaiseRealTestFailureWithoutParameters()
		  //wraps the raise statement into a method
		  
		  //this method should have a unique name for easy lookup.
		  
		  #pragma breakOnExceptions off
		  raise new RealTestFailure
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TestName() As String
		  return me.MethodInfo.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ExceptionConversion()
		  dim t as Introspection.TypeInfo = GetTypeInfo(RealTest)
		  dim s as RealTest
		  for each m as Introspection.MethodInfo in t.GetMethods
		    if m.Name = "RaiseNilObjectException" then
		      s = new RealTest(m)
		      exit
		    end if
		  next
		  
		  
		  dim x as ExceptionTestMethod = AddressOf s.Execute
		  x.ShouldRaise GetTypeInfo(RealTestFailure)
		  
		  //only if the test above passes will this test be executed, so we should only need to catch
		  //RealTestFailures.
		  try
		    s.Execute
		    
		  catch failure as RealTestFailure
		    failure.ActualValue.StringValue.ShouldEqual "NilObjectException"
		  end try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_Execute_RaisesRealTestFailure()
		  dim thisclassinfo as Introspection.TypeInfo = GetTypeInfo(RealTest)
		  dim test_method_info as Introspection.MethodInfo
		  for each item as Introspection.MethodInfo in thisclassinfo.GetMethods
		    if item.Name = "RaiseRealTestFailureWithoutParameters" then
		      test_method_info = item
		      exit
		    end if
		  next
		  
		  dim test as new RealTest(test_method_info)
		  dim x as ExceptionTestMethod = AddressOf test.Execute
		  x.ShouldRaise GetTypeInfo(RealTestFailure)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private MethodInfo As Introspection.MethodInfo
	#tag EndProperty


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
