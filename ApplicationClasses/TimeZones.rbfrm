#tag Window
Begin Window TimeZones
   BackColor       =   16777215
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   416
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
   Title           =   "Time Zones"
   Visible         =   True
   Width           =   712
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
      HasHeading      =   True
      HeadingIndex    =   -1
      Height          =   416
      HelpTag         =   ""
      Hierarchical    =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "Time Zones"
      Italic          =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   ""
      LockTop         =   True
      RequiresSelection=   ""
      Scope           =   0
      ScrollbarHorizontal=   ""
      ScrollBarVertical=   True
      SelectionType   =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   0
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   268
      _ScrollWidth    =   -1
   End
   Begin Label NameViewer
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   288
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Name"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   14
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   404
   End
   Begin Label CurrentOffsetViewer
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   288
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Current Offset"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   62
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   404
   End
   Begin Label IsDSTViewer
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   288
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "isDST"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   86
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   404
   End
   Begin Label AbbrViewer
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   288
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Abbreviation"
      TextAlign       =   0
      TextColor       =   0
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   36
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   404
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Open()
		  dim L as LIstbox = Listbox1
		  for each name as String in TimeZone.Names
		    L.AddRow name
		  next
		  
		  //mark the system time zone.
		  
		  #if targetMacOS or targetLinux
		    dim systemTZ as TimeZone = TimeZone.SystemTimeZone
		    if systemTZ <> nil then
		      for row as Integer = 0 to L.ListCount - 1
		        if L.Cell(row, 0) = systemTZ.Name then
		          L.CellBold(row, 0) = true
		          L.ListIndex = row
		          exit
		        end if
		      next
		    end if
		  #endif
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub SetViewers(tz as TimeZone)
		  if tz = nil then
		    return
		  end if
		  
		  NameViewer.Text = "Name: " + tz.Name
		  AbbrViewer.Text = "Abbreviation: " + tz.Abbreviation
		  CurrentOffsetViewer.Text = "Current Offset: " + Format(tz.Offset(), "-0000")
		  IsDSTViewer.Text = "Is Daylight Savings Time: " + Str(tz.IsDST)
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag Events Listbox1
	#tag Event
		Sub Change()
		  if me.ListIndex > -1 then
		    SetViewers(TimeZone.Get(me.Cell(me.ListIndex, 0)))
		  else
		    //
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
