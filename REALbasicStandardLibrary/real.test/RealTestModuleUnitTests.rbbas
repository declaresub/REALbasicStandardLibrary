#tag Class
Protected Class RealTestModuleUnitTests
	#tag Method, Flags = &h21
		Private Shared Sub FailingBooleanTest()
		  dim b as Boolean = true
		  b.ShouldEqual false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub FailingIntegerTest()
		  dim actualvalue as Integer = 13
		  dim expectedvalue as Integer = 17
		  
		  actualvalue.ShouldEqual expectedvalue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub FailingVariantTest()
		  dim a as Variant = "a"
		  dim b as Variant = 1
		  dim c as Variant = true
		  
		  dim actualValue() as Variant = Array(a, c, b)
		  dim expectedvalue() as Variant = Array(a, b, c)
		  actualValue.ShouldEqual expectedvalue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub RaiseNilObjectException()
		  #pragma breakOnExceptions off
		  
		  raise new NilObjectException
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub RaiseNoException()
		  return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub ShouldRaise_NoException()
		  //this method is invoked by Test_ShouldRaiseNoException.
		  
		  dim t as ExceptionTestMethod = AddressOf RaiseNoException
		  t.ShouldRaise GetTypeInfo(RuntimeException)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub ShouldRaise_WrongExceptionType()
		  dim t as ExceptionTestMethod = AddressOf RaiseNilObjectException
		  t.ShouldRaise GetTypeInfo(OutOfBoundsException)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldBeA()
		  dim t as new RealTestFailure
		  t.ShouldBeA GetTypeInfo(RealTestFailure)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldBeAtMost_Date()
		  dim expectedValue as new Date
		  expectedValue.SQLDateTime = "2009-08-07 12:12:12"
		  dim actualValue as new Date
		  actualValue.SQLDateTime = "2009-08-06 12:12:12"
		  
		  actualValue.ShouldBeAtMost expectedValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldBe_Success()
		  dim c1 as new RealTestFailure
		  dim c2 as RealTestFailure = c1
		  c2.ShouldBe c1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldEqualDate_Success()
		  dim sqldatetime as String = "2009-08-04 12:24:33"
		  dim actualvalue as new Date
		  actualvalue.SQLDateTime = sqldatetime
		  dim expectedvalue as new Date
		  expectedvalue.SQLDateTime = sqldatetime
		  
		  actualvalue.ShouldEqual expectedvalue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldEqualStringArray_Success()
		  dim expectedvalue() as String = Array("a", "b", "c")
		  expectedvalue.ShouldEqual expectedvalue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldEqualString_Success()
		  dim actualvalue as String = "foo"
		  dim expectedvalue as String = "foo"
		  
		  actualvalue.ShouldEqual expectedvalue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldEqual_Boolean_Failure()
		  dim test as ExceptionTestMethod = AddressOf FailingBooleanTest
		  test.ShouldRaise GetTypeInfo(RealTestFailure)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldEqual_Boolean_Success()
		  dim actualvalue as Boolean = true
		  dim expectedvalue as Boolean = true
		  
		  actualvalue.ShouldEqual expectedvalue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldEqual_Integer_Failure()
		  dim t as ExceptionTestMethod = AddressOf FailingIntegerTest
		  t.ShouldRaise GetTypeInfo(RealTestFailure)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldEqual_Integer_Success()
		  dim actualvalue as Integer = 13
		  dim expectedvalue as Integer = 13
		  
		  actualvalue.ShouldEqual expectedvalue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldEqual_VariantArray_Failure()
		  dim t as ExceptionTestMethod = AddressOf FailingVariantTest
		  t.ShouldRaise GetTypeInfo(RealTestFailure)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldEqual_VariantArray_Success()
		  dim a as Variant = "a"
		  dim b as Variant = 1
		  dim c as Variant = true
		  
		  dim expectedvalue() as Variant = Array(a, b, c)
		  expectedvalue.ShouldEqual expectedvalue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldNotEqualString_Success()
		  dim actualvalue as String = "foo"
		  dim expectedvalue as String = "bar"
		  
		  actualvalue.ShouldNotEqual expectedvalue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldRaiseNilObjectException()
		  dim t as ExceptionTestMethod = AddressOf RaiseNilObjectException
		  t.ShouldRaise GetTypeInfo(NilObjectException)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldRaiseNoException()
		  dim t as ExceptionTestMethod = AddressOf ShouldRaise_NoException
		  t.ShouldRaise GetTypeInfo(RealTestFailure)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_ShouldRaise_WrongExceptionType()
		  dim t as ExceptionTestMethod = AddressOf ShouldRaise_WrongExceptionType
		  t.ShouldRaise GetTypeInfo(RealTestFailure)
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
