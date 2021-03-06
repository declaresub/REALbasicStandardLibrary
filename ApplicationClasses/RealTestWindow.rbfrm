#tag Window
Begin Window RealTestWindow
   BackColor       =   &hFFFFFF
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   6.02e+2
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "RealTest"
   Visible         =   True
   Width           =   6.4e+2
   Begin PushButton RunTestsButton
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Run Tests"
      Default         =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   513
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   562
      Underline       =   ""
      Visible         =   True
      Width           =   107
   End
   Begin Listbox Listbox1
      AutoDeactivate  =   True
      AutoHideScrollbars=   True
      Bold            =   ""
      Border          =   True
      ColumnCount     =   1
      ColumnsResizable=   ""
      ColumnWidths    =   ""
      DataField       =   ""
      DataSource      =   ""
      DefaultRowHeight=   -1
      Enabled         =   True
      EnableDrag      =   ""
      EnableDragReorder=   ""
      GridLinesHorizontal=   0
      GridLinesVertical=   0
      HasHeading      =   ""
      HeadingIndex    =   -1
      Height          =   401
      HelpTag         =   ""
      Hierarchical    =   True
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   ""
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   0
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   640
      _ScrollWidth    =   -1
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h21
		Private Shared Function DictFromClassElement(element as XMLElement) As Dictionary
		  dim d as new Dictionary
		  d.Value("Name") = element.GetAttribute("Name")
		  d.Value("FullName") = element.GetAttribute("Name")
		  dim testResults() as Dictionary
		  dim testsPassed as Boolean = true
		  for i as Integer = 0 to element.ChildCount - 1
		    dim node as XMLNode = element.Child(i)
		    if node isA XMLElement then
		      dim testDict as Dictionary = DictFromTestResultElement(XMLElement(node), element.GetAttribute("Name"))
		      testResults.Append testDict
		      testsPassed = testsPassed and testDict.Value("Passed").BooleanValue
		    end if
		  next
		  
		  d.Value("TestResults") = testResults
		  d.Value("TextColor") = RowTextColor(testsPassed)
		  return d
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function DictFromTestResultElement(element as XMLElement, className as String) As Dictionary
		  dim d as new Dictionary
		  
		  d.Value("Name") = element.GetAttribute("Name")
		  d.Value("FullName") = className + "." + element.GetAttribute("Name")
		  d.Value("Passed") = element.GetAttribute("Passed") = "true"
		  d.Value("ExecutionTime") = Val(element.GetAttribute("ExecutionTime"))
		  d.Value("TextColor") = RowTextColor(d.Value("Passed"))
		  
		  //still need to add error information for failed tests
		  
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function RowTextColor(testPassed as Boolean) As Color
		  if testPassed then
		    return TextColorPassed
		  else
		    return TextColorFailed
		  end if
		End Function
	#tag EndMethod


	#tag Constant, Name = TextColorFailed, Type = Color, Dynamic = False, Default = \"&cff0000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = TextColorPassed, Type = Color, Dynamic = False, Default = \"&c000000", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events RunTestsButton
	#tag Event
		Sub Action()
		  dim results as RealTestResults = RealTestModule.ExecuteTests(RealTestClassRegistry.ClassList)
		  
		  Listbox1.DeleteAllRows
		  
		  dim root as XMLElement = results.DocumentElement
		  if root is nil then
		    //this seems like a problem
		    return
		  end if
		  
		  for i as Integer = 0 to root.ChildCount - 1
		    dim child as XMLNode = root.Child(i)
		    if child isA XMLElement then
		      dim element as XMLElement = XMLElement(child)
		      if element.Name = "Class" then
		        dim nameAttributeValue as String = element.GetAttribute("Name")
		        if nameAttributeValue <> "" then
		          Listbox1.AddFolder nameAttributeValue
		          Listbox1.RowTag(Listbox1.LastIndex) = DictFromClassElement(element)
		        else
		          //something's wrong with the XML.
		        end if
		      end if
		    end if
		  next
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Listbox1
	#tag Event
		Sub ExpandRow(row As Integer)
		  
		  
		  dim d as Dictionary = me.RowTag(row)
		  if d <> nil then
		    dim testResults() as Dictionary = d.Value("TestResults")
		    for each testResult as Dictionary in testResults
		      me.AddRow testResult.Value("Name").stringValue
		      me.RowTag(me.LastIndex) = testResult
		    next
		  end if
		End Sub
	#tag EndEvent
	#tag Event
		Function CellTextPaint(g As Graphics, row As Integer, column As Integer, x as Integer, y as Integer) As Boolean
		  #pragma unused column
		  #pragma unused x
		  #pragma unused y
		  
		  if row < me.ListCount then
		    dim d as Dictionary = me.RowTag(row)
		    g.ForeColor = d.Value("TextColor")
		  end if
		  
		  return false
		  
		End Function
	#tag EndEvent
	#tag Event
		Sub DoubleClick()
		  //IDE Script communication is broken; see <feedback://showreport?report_id=13143> and <feedback://showreport?report_id=15942>
		  
		  if me.ListIndex = -1 then
		    return
		  end if
		  
		  dim d as Dictionary = me.RowTag(me.ListIndex)
		  if d is nil then
		    //I've made a bad assumption
		    return
		  end if
		  
		  dim name as String = d.Value("FullName")
		  if name = "" then
		    //this would also be a mistake
		    return
		  end if
		  
		  '//may need to select project window in case multiple projects are open
		  IDECommunicator.SendScript "Location = """ + name + """"
		  
		  //bring IDE to the front
		  #if targetMacOS
		    dim ae as new AppleEvent("misc", "actv", "com.realsoftware.realstudio")
		    dim b as Boolean = ae.Send
		    #pragma unused b
		  #endif
		  #if targetWin32
		    //figure out a good way to activate IDE.
		  #endif
		  #if targetLinux
		    //figure out a good way to activate IDE.
		  #endif
		  
		End Sub
	#tag EndEvent
#tag EndEvents
