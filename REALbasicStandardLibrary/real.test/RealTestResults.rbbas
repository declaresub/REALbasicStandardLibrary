#tag Class
Protected Class RealTestResults
Inherits XMLDocument
	#tag Method, Flags = &h0
		Function FormatAsHTML() As String
		  return self.Transform(TestResultsXSL)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatAsText() As String
		  return self.Transform(XSL_PlainText)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SendTestOutputToBrowser()
		  #if targetHasGUI
		    dim f as FolderItem = SpecialFolder.Temporary.TrueChild("Results.html")
		    const overwrite = true
		    dim b as BinaryStream = BinaryStream.Create(f, overwrite)
		    b.Write self.FormatAsHTML()
		    b = nil
		    
		    ShowURL f.URLPath
		  #endif
		End Sub
	#tag EndMethod


	#tag Constant, Name = TestResultsXSL, Type = String, Dynamic = False, Default = \"<\?xml version\x3D\"1.0\" encoding\x3D\"UTF-8\"\?>\r<xsl:stylesheet version\x3D\"1.0\" xmlns:xsl\x3D\"http://www.w3.org/1999/XSL/Transform\"> <xsl:template match\x3D\"/RealTestResults\"> \r<html>\r<title> Test Results: <xsl:value-of select\x3D\"@ProjectName\" /> </title>\r<body>\r<h2 align\x3D\"center\">\r\tTest Results: <xsl:value-of select\x3D\"@ProjectName\" /> \r</h2>\r<h3>Version: <xsl:value-of select\x3D\"@Version\" /></h3> \r<h3>Build Target: <xsl:value-of select\x3D\"@BuildTarget\" /> </h3>\r\r<xsl:apply-templates select\x3D\"Class\" /> \r</body>\r</html>\r</xsl:template> <xsl:template match\x3D\"Class\"> \r<h4>\r\t<xsl:value-of select\x3D\"@Name\" /> \r</h4>\r<table>\r\t<tr>\r\t\t<th> Test </th>\r\t\t<th> Result </th>\r\t</tr>\r\t<xsl:apply-templates select\x3D\"TestResult\" /> \r</table>\r</xsl:template> <xsl:template match\x3D\"TestResult\"> <xsl:choose> <xsl:when test\x3D\"@Passed\x3D\'true\'\"> \r<tr bgcolor\x3D\"#00FF00\">\r\t<td> <xsl:value-of select\x3D\"@Name\" /> </td>\r\t<td> Passed </td>\r</tr>\r</xsl:when> <xsl:otherwise> \r<tr bgcolor\x3D\"#FF0000\">\r\t<td> <xsl:value-of select\x3D\"@Name\" /> </td>\r\t<td> Failed </td>\r</tr>\r</xsl:otherwise> </xsl:choose> </xsl:template> </xsl:stylesheet> ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = XSL_PlainText, Type = String, Dynamic = False, Default = \"<xsl:stylesheet version\x3D\"1.0\" xmlns:xsl\x3D\"http://www.w3.org/1999/XSL/Transform\">\r\r<xsl:variable name\x3D\"newline\"><xsl:text>\r</xsl:text></xsl:variable>\r\r<xsl:output method\x3D\"text\" />\r<xsl:template match\x3D\"/UnitTestResults\">Test Results <xsl:apply-templates select\x3D\"Class\" />\r</xsl:template>\r<xsl:template match\x3D\"Class\">\rClass <xsl:value-of select\x3D\"@Name\" />: \r<xsl:apply-templates select\x3D\"TestResult\" />\r</xsl:template>\r<xsl:template match\x3D\"TestResult\">\r<xsl:choose>\r<xsl:when test\x3D\"@Passed\x3D\'true\'\">\r<xsl:text>    </xsl:text><xsl:value-of select\x3D\"@Name\" />: Passed \r</xsl:when>\r<xsl:otherwise>\r<xsl:text>    </xsl:text><xsl:value-of select\x3D\"@Name\" />: Failed \r<xsl:text>        </xsl:text>Expected Value: <xsl:value-of select\x3D\"ExpectedValue\" />\r<xsl:value-of select\x3D\"$newline\" />\r<xsl:text>        </xsl:text>Actual Value: <xsl:value-of select\x3D\"ActualValue\" />\r<xsl:value-of select\x3D\"$newline\" />\r<xsl:text>        </xsl:text>Stack Trace: \r<xsl:text>        </xsl:text><xsl:value-of select\x3D\"StackTrace\" />\r<xsl:value-of select\x3D\"$newline\" />\r</xsl:otherwise>\r</xsl:choose>\r</xsl:template>\r</xsl:stylesheet>\r", Scope = Private
	#tag EndConstant


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
