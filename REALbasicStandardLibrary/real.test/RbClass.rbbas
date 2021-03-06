#tag Class
Protected Class RbClass
	#tag Method, Flags = &h0
		Function AttributeValue(name as String) As Variant
		  dim info as Introspection.AttributeInfo = nil
		  for each item as Introspection.AttributeInfo in self.TypeInfo.GetAttributes
		    if item.Name = name then
		      info = item
		      exit
		    end if
		  next
		  if info <> nil then
		    return info.Value
		  else
		    return nil
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ClassInfo() As Introspection.TypeInfo
		  return GetTypeInfo(RbClass)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(t as Introspection.TypeInfo)
		  me.TypeInfo = t
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function DefaultTestMethodPredicate(method_info as Introspection.MethodInfo) As Boolean
		  return (IsTestName(method_info.Name) or HasTestAttribute(GetAttributeInfoByName(method_info, TestMethodAttributeName)))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetAttributeInfoByName(method_info as Introspection.MethodInfo, name as String) As Introspection.AttributeInfo
		  dim info as Introspection.AttributeInfo = nil
		  for each item as Introspection.AttributeInfo in method_info.GetAttributes
		    if item.Name = name then
		      info = item
		      exit
		    end if
		  next
		  return info
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetMethodInfoByName(class_info as Introspection.TypeInfo, name as String) As Introspection.MethodInfo
		  dim info as Introspection.MethodInfo = nil
		  for each item as Introspection.MethodInfo in class_info.GetMethods
		    if item.Name = name then
		      info = item
		      exit
		    end if
		  next
		  return info
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function HasTestAttribute(info as Introspection.AttributeInfo) As Boolean
		  return info <> nil and info.Name = TestMethodAttributeName and info.Value.BooleanValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function IsTestMethod(method_info as Introspection.MethodInfo) As Boolean
		  dim p as MethodInfoPredicateDelegate = TestMethodPredicate
		  if p is nil then
		    p = AddressOf DefaultTestMethodPredicate
		  end if
		  
		  return method_info.IsShared and p.Invoke(method_info)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function IsTestName(name as String) As Boolean
		  return InStr(name, TestMethodPrefix) = 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function List(classList() as Introspection.TypeInfo) As RbClass()
		  dim L() as RbClass
		  for each item as Introspection.TypeInfo in classList
		    L.Append new RbClass(item)
		  next
		  return L
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function MethodInfoPredicateDelegate(method_info as Introspection . MethodInfo) As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Function TestList() As RealTest()
		  dim theList() as RealTest
		  
		  for each member as Introspection.MethodInfo in me.TypeInfo.GetMethods
		    if IsTestMethod(member) then
		      theList.Append new RealTest(member)
		    end if
		  next
		  
		  return theList
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ClassName()
		  dim s() as String = Split(CurrentMethodName, ".")
		  if UBound(s) > -1 then
		    s.Remove UBound(s)
		  end if
		  dim expectedName as String = Join(s, ".")
		  
		  dim c as new RbClass(ClassInfo)
		  c.ClassName.ShouldEqual expectedName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_Constructor()
		  dim info as Introspection.TypeInfo = ClassInfo
		  
		  dim c as new RbClass(info)
		  c.TypeInfo.ShouldBe info
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Attributes( RealTest = true ) Private Shared Sub Test_GetAttributeInfoByName()
		  dim methodName as String = NthField(CurrentMethodName, ".", CountFields(CurrentMethodName, "."))
		  
		  dim method_info as Introspection.MethodInfo = GetMethodInfoByName(ClassInfo, methodName)
		  dim attribute_info as Introspection.AttributeInfo = GetAttributeInfoByName(method_info, TestMethodAttributeName)
		  attribute_info.Name.ShouldEqual TestMethodAttributeName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_GetMethodInfoByName()
		  const expectedName = "Test_GetMethodInfoByName"
		  dim method_info as Introspection.MethodInfo = GetMethodInfoByName(ClassInfo, expectedName)
		  method_info.Name.ShouldEqual expectedName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_List()
		  dim classList() as Introspection.TypeInfo = Array(GetTypeInfo(RbClass))
		  dim L() as RbClass = List(classList)
		  UBound(L).ShouldEqual 0
		  L(0).ClassName.ShouldEqual ClassInfo.FullName
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return me.TypeInfo.FullName
			End Get
		#tag EndGetter
		ClassName As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Shared TestMethodPredicate As MethodInfoPredicateDelegate
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TypeInfo As Introspection.TypeInfo
	#tag EndProperty


	#tag Constant, Name = TestMethodAttributeName, Type = String, Dynamic = False, Default = \"RealTest", Scope = Private
	#tag EndConstant

	#tag Constant, Name = TestMethodPrefix, Type = String, Dynamic = False, Default = \"Test_", Scope = Private
	#tag EndConstant

	#tag Constant, Name = TestResultsXSL, Type = String, Dynamic = False, Default = \"<\?xml version\x3D\"1.0\" encoding\x3D\"UTF-8\"\?>\r<xsl:stylesheet version\x3D\"1.0\" xmlns:xsl\x3D\"http://www.w3.org/1999/XSL/Transform\">\r\t<xsl:template match\x3D\"/RealTestResults\">\r\t\t<html>\r\t\t\t<title>\r\t\t\t\tTest Results: \r\t\t\t\t<xsl:value-of select\x3D\"@ProjectName\" />\r\t\t\t</title>\r\t\t\t<body>\r\t\t\t\t<h2 align\x3D\"center\">\r\t\t\t\t\tTest Results: \r\t\t\t\t\t<xsl:value-of select\x3D\"@ProjectName\" />\r\t\t\t\t</h2>\r\t\t\t\t<xsl:apply-templates select\x3D\"Class\" />\r\t\t\t</body>\r\t\t</html>\r\t</xsl:template>\r\t<xsl:template match\x3D\"Class\">\r\t\t<h4>\r\t\t\t<xsl:value-of select\x3D\"@Name\" />\r\t\t</h4>\r\t\t<table>\r\t\t\t<tr>\r\t\t\t\t<th>\r\t\t\t\t\tTest \r\t\t\t\t</th>\r\t\t\t\t<th>\r\t\t\t\t\tResult \r\t\t\t\t</th>\r\t\t\t</tr>\r\t\t\t<xsl:apply-templates select\x3D\"TestResult\" />\r\t\t</table>\r\t</xsl:template>\r\t<xsl:template match\x3D\"TestResult\">\r\t\t<xsl:choose>\r\t\t\t<xsl:when test\x3D\"@Passed\x3D\'true\'\">\r\t\t\t\t<tr bgcolor\x3D\"#00FF00\">\r\t\t\t\t\t<td>\r\t\t\t\t\t\t<xsl:value-of select\x3D\"@Name\" />\r\t\t\t\t\t</td>\r\t\t\t\t\t<td>\r\t\t\t\t\t\tPassed\r\t\t\t\t\t</td>\r\t\t\t\t</tr>\r\t\t\t</xsl:when>\r\t\t\t<xsl:otherwise>\r\t\t\t\t<tr bgcolor\x3D\"#FF0000\">\r\t\t\t\t\t<td>\r\t\t\t\t\t\t<xsl:value-of select\x3D\"@Name\" />\r\t\t\t\t\t</td>\r\t\t\t\t\t<td>\r\t\t\t\t\t\tFailed\r\t\t\t\t\t</td>\r\t\t\t\t</tr>\r\t\t\t</xsl:otherwise>\r\t\t</xsl:choose>\r\t</xsl:template>\r</xsl:stylesheet>\r", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="ClassName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
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
