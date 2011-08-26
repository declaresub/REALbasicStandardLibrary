#tag Module
Protected Module RealTestModule
	#tag Method, Flags = &h0
		Sub Assert(assertion as Boolean, msg as String = "")
		  //there are assertions that don't lend themselves to expression using our little language. The example that led to the addition of Assert is
		  // comparison of two delegates whose type is private.
		  
		  if not assertion then
		    dim err as new RealTestFailure
		    err.Message = msg
		    raise err
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BuildTarget() As String
		  #if targetCocoa
		    return "Mac OS Cocoa"
		  #elseIf targetCarbon
		    return "Mac OS Carbon"
		  #elseIf targetWin32
		    return "Windows"
		  #elseif targetLinux
		    return "Linux"
		    
		  #else
		    return ""
		  #endif
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub ExceptionTestMethod()
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h1
		Protected Function ExecuteTests(classList() as Introspection.TypeInfo, filterClasses as RbClassPredicate = nil) As RealTestResults
		  dim L() as RbClass
		  
		  if filterClasses <> nil then
		    for each item as RbClass in RbClass.List(classList)
		      if filterClasses.Invoke(item) then
		        L.Append item
		      end if
		    next
		  else
		    L = RbClass.List(classList)
		  end if
		  
		  return ExecuteTests(L)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ExecuteTests(classList() as RbClass) As RealTestResults
		  dim xml as new RealTestResults
		  dim root as XMLElement = xml.CreateElement("RealTestResults")
		  root.SetAttribute "ProjectName", App.ExecutableFile.Name
		  dim now as new Date
		  root.SetAttribute "Date", now.SQLDateTime
		  root.SetAttribute "Version", RbVersionString
		  root.SetAttribute "BuildTarget", BuildTarget
		  xml.AppendChild(root)
		  
		  
		  
		  for each item as RbClass in classList
		    dim classNode as XMLElement = xml.CreateElement("Class")
		    classNode.SetAttribute "Name", item.ClassName
		    root.AppendChild classNode
		    
		    
		    for each test as RealTest in SortTestsByName(item.TestList)
		      
		      dim testNode as XMLElement = xml.CreateElement("TestResult")
		      testNode.SetAttribute "Name", test.TestName
		      classNode.AppendChild testNode
		      
		      dim executionStart as Double = Microseconds
		      try
		        test.Execute
		        testNode.SetAttribute "Passed", "true"
		        
		      catch failure as RealTestFailure
		        testNode.SetAttribute "Passed", "false"
		        dim expectedValueNode as XMLElement = xml.CreateElement("ExpectedValue")
		        testNode.AppendChild expectedValueNode
		        expectedValueNode.AppendChild xml.CreateCDATASection(failure.ExpectedValue)
		        dim actualValueNode as XMLElement = xml.CreateElement("ActualValue")
		        testNode.AppendChild actualValueNode
		        actualValueNode.AppendChild xml.CreateCDATASection(failure.ActualValue)
		        dim stackNode as XMLElement = xml.CreateElement("StackTrace")
		        testNode.AppendChild stackNode
		        stackNode.AppendChild xml.CreateCDATASection(Join(failure.Stack, EndOfLine))
		        
		      finally
		        dim executionComplete as Double = Microseconds
		        testNode.SetAttribute "ExecutionTime", Format(executionComplete - executionStart, "#")
		      end try
		    next
		    
		  next
		  
		  return xml
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FilterClassesWithNoTests(L() as RbClass) As RbClass()
		  dim F() as RbClass
		  for each item as RbClass in L
		    if UBound(item.TestList) > -1 then
		      F.Append item
		    end if
		  next
		  return F
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function hasTests(c as RbClass) As Boolean
		  return c <> nil and UBound(c.TestList) > -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ObjectInfo(obj as Object) As String
		  if obj <> nil then
		    dim v as Variant = obj
		    return Introspection.GetType(obj).FullName + ": hash = " + Format(v.Hash, "0")
		  else
		    return "Nil"
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseRealTestFailure(actualValue as Variant, expectedvalue as Variant, msg as String = "")
		  #pragma breakOnExceptions off
		  
		  dim err as new RealTestFailure
		  err.Message = msg
		  err.ActualValue = actualValue
		  err.ExpectedValue = expectedvalue
		  raise err
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function RbClassPredicate(c as RbClass) As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Sub ShouldBe(extends actualvalue as Object, expectedvalue as Object)
		  if not (actualvalue is expectedvalue) then
		    RaiseRealTestFailure ObjectInfo(actualValue), ObjectInfo(expectedvalue)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldBeA(extends obj as Object, expectedType as Introspection.TypeInfo)
		  dim actualType as Introspection.TypeInfo = Introspection.GetType(obj)
		  if actualType <> expectedType then
		    RaiseRealTestFailure(actualType.FullName, expectedType.FullName)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldBeAtMost(extends actualValue as Date, expectedValue as Date)
		  if not (actualvalue <= expectedvalue) then
		    RaiseRealTestFailure(actualValue, expectedValue)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldBeGreaterThan(extends actualvalue as Integer, expectedvalue as Integer)
		  if not (actualvalue > expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldBeLessThan(extends actualvalue as Integer, expectedvalue as Integer)
		  if not (actualvalue < expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldBytewiseEqual(extends actualvalue as String, expectedvalue as String)
		  if StrComp(actualvalue, expectedvalue, 0) <> 0 then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue as Boolean, expectedvalue as Boolean)
		  if (actualvalue <> expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue as Boolean, expectedvalue as Boolean, msg as String)
		  if (actualvalue <> expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue, msg
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue as Date, expectedvalue as Date)
		  if (actualvalue <> expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue as Double, expectedvalue as Double)
		  if (actualvalue <> expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue as Integer, expectedvalue as Integer)
		  if (actualvalue <> expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue() as Pair, expectedvalue() as Pair)
		  if UBound(actualvalue) <> UBound(expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		  
		  for i as Integer = 0 to UBound(actualvalue)
		    actualvalue(i).ShouldEqual expectedvalue(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue as Pair, expectedvalue as Pair)
		  if (actualvalue.Left <> expectedvalue.Left) or (actualvalue.Right <> expectedvalue.Right) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue() as String, expectedvalue() as String)
		  if UBound(actualvalue) <> UBound(expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		  
		  for i as Integer = 0 to UBound(actualvalue)
		    actualvalue(i).ShouldEqual expectedvalue(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue as String, expectedvalue as String)
		  if (actualvalue <> expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue() as Variant, expectedvalue() as Variant)
		  if UBound(actualvalue) <> UBound(expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		  
		  for i as Integer = 0 to UBound(actualvalue)
		    actualvalue(i).ShouldEqual expectedvalue(i)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldEqual(extends actualvalue as Variant, expectedvalue as Variant)
		  if (actualValue.Type <> expectedValue.Type) or (actualvalue <> expectedvalue) then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldNotBe(extends actualvalue as Object, expectedvalue as Object)
		  if actualvalue is expectedvalue then
		    RaiseRealTestFailure ObjectInfo(actualValue), ObjectInfo(expectedvalue)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldNotEqual(extends actualvalue as Integer, expectedvalue as Integer)
		  if actualvalue = expectedvalue then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldNotEqual(extends actualvalue as String, expectedvalue as String)
		  if actualvalue = expectedvalue then
		    RaiseRealTestFailure actualValue, expectedvalue
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShouldRaise(extends t as ExceptionTestMethod, exceptionType as Introspection.TypeInfo)
		  dim actualExceptionRaised as RuntimeException = nil
		  try
		    #pragma breakOnExceptions off
		    t.Invoke
		  catch e as RuntimeException
		    actualExceptionRaised = e
		  end try
		  
		  if Introspection.GetType(actualExceptionRaised) <> exceptionType then
		    if actualExceptionRaised <> nil then
		      RaiseRealTestFailure Introspection.GetType(actualExceptionRaised).Name, exceptionType.Name
		    else
		      RaiseRealTestFailure "", exceptionType.Name
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SkipClassesWithNoTests() As RbClassPredicate
		  return AddressOf hasTests
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SortTestsByName(testList() as RealTest) As RealTest()
		  dim L() as RealTest
		  dim names() as String
		  for i as Integer = 0 to UBound(testList)
		    L.Append testList(i)
		    names.Append testList(i).TestName
		  next
		  
		  names.SortWith L
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
