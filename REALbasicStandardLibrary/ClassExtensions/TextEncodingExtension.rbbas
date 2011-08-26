#tag Module
Protected Module TextEncodingExtension
	#tag Method, Flags = &h0
		Function ACK(extends t as TextEncoding) As String
		  return t.Chr(6)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BEL(extends t as TextEncoding) As String
		  return t.Chr(7)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BS(extends t as TextEncoding) As String
		  return t.Chr(8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CAN(extends t as TextEncoding) As String
		  return t.Chr(24)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CR(extends t as TextEncoding) As String
		  return t.Chr(13)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DC1(extends t as TextEncoding) As String
		  return t.Chr(17)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DC2(extends t as TextEncoding) As String
		  return t.Chr(18)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DC3(extends t as TextEncoding) As String
		  return t.Chr(19)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DC4(extends t as TextEncoding) As String
		  return t.Chr(20)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DEL(extends t as TextEncoding) As String
		  return t.Chr(127)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DLE(extends t as TextEncoding) As String
		  return t.Chr(16)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EM(extends t as TextEncoding) As String
		  return t.Chr(25)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ENQ(extends t as TextEncoding) As String
		  return t.Chr(5)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EOT(extends t as TextEncoding) As String
		  return t.Chr(4)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ESC(extends t as TextEncoding) As String
		  return t.Chr(27)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ETB(extends t as TextEncoding) As String
		  return t.Chr(23)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ETX(extends t as TextEncoding) As String
		  return t.Chr(3)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FF(extends t as TextEncoding) As String
		  return t.Chr(12)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FS(extends t as TextEncoding) As String
		  return t.Chr(28)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GS(extends t as TextEncoding) As String
		  return t.Chr(29)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LF(extends t as TextEncoding) As String
		  return t.Chr(10)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NAK(extends t as TextEncoding) As String
		  return t.Chr(21)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NUL(extends t as TextEncoding) As String
		  return t.Chr(0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RS(extends t as TextEncoding) As String
		  return t.Chr(30)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SI(extends t as TextEncoding) As String
		  return t.Chr(15)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SO(extends t as TextEncoding) As String
		  return t.Chr(14)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SOH(extends t as TextEncoding) As String
		  return t.Chr(1)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function STX(extends t as TextEncoding) As String
		  return t.Chr(2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SUB_(extends t as TextEncoding) As String
		  //SUB is a reserved word in REALbasic; hence the trailing underscore.
		  return t.Chr(26)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SYN(extends t as TextEncoding) As String
		  return t.Chr(22)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TAB(extends t as TextEncoding) As String
		  return t.Chr(8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function US(extends t as TextEncoding) As String
		  return t.Chr(31)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VT(extends t as TextEncoding) As String
		  return t.Chr(11)
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
