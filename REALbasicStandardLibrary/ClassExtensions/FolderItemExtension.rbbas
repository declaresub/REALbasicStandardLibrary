#tag Module
Protected Module FolderItemExtension
	#tag Method, Flags = &h0
		Function TrueItems(extends f as FolderItem) As FolderItem()
		  if not f.DIrectory then
		    dim emptyList() as FolderItem
		    return emptyList
		  end if
		  
		  
		  #if targetMacOS
		    return f.TrueItems_MacOS
		  #endif
		  
		  #if targetWin32
		    return f.TrueItems_Win32
		  #endif
		  
		  #if targetLinux
		    return f.TrueItems_Linux
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TrueItems_Linux(extends f as FolderItem) As FolderItem()
		  #if targetLinux
		    #pragma disableBackgroundTasks
		    
		    soft declare function opendir lib libc.libc (dirname as CString) as Ptr
		    soft declare function readdir lib libc.libc (dirp as Ptr) as Ptr
		    soft declare function closedir lib libc.libc (dirp as Ptr) as Integer
		    
		    
		    dim names() as String
		    
		    dim dirp as Ptr = opendir(f.AbsolutePath)
		    if dirp = nil then
		      raise new libcError(libcError.GetErrorCode)
		    end if
		    try
		      do
		        dim entry_p as MemoryBlock = readdir(dirp)
		        //check for error.
		        if entry_p <> nil then
		          names.Append DefineEncoding(entry_p.CString(8), Encodings.UTF8)
		        else
		          dim errorCode as Integer = libcError.GetErrorCode
		          if errorCode = 0 then
		            //no more entries
		            exit
		          else
		            raise new libcError(errorCode)
		          end if
		        end if
		      loop
		      
		    finally
		      dim closedir_result as Integer = closedir(dirp)
		      #pragma unused closedir_result
		      dirp = nil
		    end try
		    
		    dim theList() as FolderItem
		    
		    for each name as String in names
		      //It's possible that TrueChild might raise an UnsupportedFormatException.  It happens in Mac OS when name contains a colon, which is
		      //legal in the BSD layer, but not the Carbon layer.  I don't expect this to happen in Linux, but if it does, we should know about it.
		      theList.Append f.TrueChild(name)
		    next
		    
		    return theList
		    
		  #else
		    #pragma unused f
		  #endif
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TrueItems_MacOS(extends dir as FolderItem) As FolderItem()
		  #pragma disableBackgroundTasks
		  
		  
		  //I assume that dir is in fact a directory.
		  
		  #if targetMacOS
		    soft declare function CFURLCreateWithString lib CarbonFramework (allocator as Ptr, URLString as CFStringRef, baseURL as Ptr) as Ptr
		    soft declare function CFURLGetFSRef lib CarbonFramework (url as Ptr, byRef f as FSRef) as Boolean
		    soft declare function FSOpenIterator lib CarbonFramework (ByRef container as FSRef, iteratorFlags as UInt32, ByRef iterator as Ptr) as Int16
		    soft declare function FSCloseIterator lib CarbonFramework (iterator as Ptr) as Int16
		    soft declare function FSGetCatalogInfoBulk lib CarbonFramework (iterator as Ptr, maximumObjects as UInt32, ByRef actualObjects as Integer, ByRef containerChanged as Boolean, whichInfo as UInt32, catalogInfos as Ptr, refs as Ptr, specs as Ptr, names as Ptr) as Int16
		    soft declare function CFURLCreateFromFSRef lib CarbonFramework (allocator as Ptr, byRef f as FSRef) as Ptr
		    soft declare function CFURLGetString lib CarbonFramework (anURL as Ptr) as Ptr
		    soft declare function CFRetain lib CarbonFramework (cf as Ptr) as CFStringRef
		    
		    
		    dim urlPtr as Ptr = CFURLCreateWithString(nil, dir.URLPath, nil)
		    if urlPtr = nil then
		      raise new MacOSError("CFURLCreateWithString returned nil.")
		    end if
		    
		    dim myRef as FSRef
		    try
		      if not CFURLGetFSRef(urlPtr, myRef) then
		        raise new MacOSError("CFURLGetFSRef returned false.")
		      end if
		      
		    finally
		      CoreFoundation.Release(urlPtr)
		      urlPtr = nil
		    end try
		    
		    
		    dim theList() as FolderItem
		    
		    dim theIterator as Ptr
		    dim err as Integer = FSOpenIterator(myRef, kFSIterateFlat, theIterator)
		    if err <> MacOSError.noErr then
		      raise new MacOSError(err, "FSOpenIterator")
		    end if
		    if theIterator = nil then
		      //I wouldn't expect this to happen if err  = 0, but just in case...
		      dim emptyList(-1) as FolderItem
		      return emptyList
		    end if
		    
		    
		    
		    
		    try
		      const MaxObjectCount = 256
		      dim FSRefArray as new MemoryBlock(FSRef.Size*MaxObjectCount)
		      do
		        dim actualObjectCount as Integer
		        dim containerChanged as Boolean
		        
		        dim OSErr as Int16 = FSGetCatalogInfoBulk(theIterator, MaxObjectCount, actualObjectCount, containerChanged, kFSCatInfoNone, nil, FSRefArray, nil, nil)
		        
		        dim FSRefPtr as Ptr = FSRefArray
		        dim offset as Integer = 0
		        for i as Integer = 1 to actualObjectCount
		          #if RbVersion >= 2010.05
		            dim theItem as FolderItem = FolderItem.CreateFromMacFSRef(FSRefPtr.FSRef(offset).StringValue(targetLittleEndian))
		          #else
		            dim theItem as FolderItem
		            dim p as Ptr = CFURLCreateFromFSRef(nil, theFSRef)
		            if p <> nil then
		              try
		                dim stringPtr as Ptr = CFURLGetString(me.CFURLPtr)
		                if stringPtr <> nil then
		                  theItem = new FolderItem(CFRetain(stringPtr), FolderItem.PathTypeURL)
		                else
		                  theItem = nil
		                end if
		              finally
		                CoreFoundation.Release(p)
		                p = nil
		              end try
		            else
		              theItem = nil
		            end if
		          #endif
		          
		          offset = offset + FSRef.Size
		          if theItem <> nil then
		            theList.Append theItem
		          end if
		        next
		        
		        if OSErr = MacOSError.errFSNoMoreItems then //we're done
		          exit
		        elseIf OSErr = MacOSError.noErr then
		          //another iteration
		          
		        else //apparently something went wrong
		          raise new MacOSError(OSErr)
		        end if
		      loop
		      
		      
		    finally
		      err = FSCloseIterator(theIterator)
		      theIterator = nil
		    end try
		    
		    return theList()
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TrueItems_Win32(extends f as FolderItem) As FolderItem()
		  #if targetWin32
		    #pragma disableBackgroundTasks
		    
		    soft declare function FindFirstFile lib Kernel32 alias "FindFirstFileW" (lpFileName as WString,  lpFindFileData as Ptr) as Integer
		    soft declare function FindNextFile lib Kernel32 alias "FindNextFileW" (handle as Integer, data as Ptr) as Integer
		    soft declare function FindClose Lib Kernel32 (handle as Integer) as Boolean
		    
		    dim theList() as FolderItem
		    
		    //here I use a MemoryBlock to work around <feedback://showreport?report_id=12506>.  When accessing a structure field of type String*N, only data up to but not including the first &h00 is returned.  This means
		    //that one cannot reasonably read UTF-16 text from such a field.
		    dim find_data as new MemoryBlock(WIN32_FIND_DATA.Size)
		    dim searchHandle as Integer = FindFirstFile("\\?\" +f.AbsolutePath + "*",  find_data)
		    if searchHandle = INVALID_HANDLE_VALUE then
		      dim err as Integer = Win32Error.GetError
		      if err = 0 or err = Win32Error.ERROR_FILE_NOT_FOUND then
		        return theList
		      else
		        //log error
		        return theList
		      end if
		    end if
		    
		    try
		      //directory iteration always returns these meta-names; we want to exclude them, but it does not appear to be possible to do so using wildcard characters.
		      dim nameSkipList() as String = Array(".", "..")
		      do
		        dim childName as String = ConvertEncoding(DefineEncoding(find_data.WString(44), Encodings.UTF16), Encodings.UTF8)
		        if childName.IsNotIn(nameSkipList) then
		          theList.Append f.TrueChild(childName)
		        else
		          //skip
		        end if
		        
		        if FindNextFile(searchHandle, find_data) <> 0 then
		          //go to next iteration
		        else
		          dim err as Integer = Win32Error.GetError
		          if err <> 0 and err <> Win32Error.ERROR_NO_MORE_FILES then
		            raise new Win32Error(err)
		          end if
		          exit
		        end if
		      loop
		      
		    finally
		      //if FindFirstFileEx returned an invalid handle, the function should have returned early.
		      dim b as Boolean = FindClose(searchHandle)
		      searchHandle = INVALID_HANDLE_VALUE
		    end try
		    
		    return theList
		    
		  #else
		    #pragma unused f
		  #endif
		End Function
	#tag EndMethod


	#tag Constant, Name = CarbonFramework, Type = String, Dynamic = False, Default = \"Carbon.framework", Scope = Private
	#tag EndConstant

	#tag Constant, Name = INVALID_HANDLE_VALUE, Type = Double, Dynamic = False, Default = \"-1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = Kernel32, Type = String, Dynamic = False, Default = \"Kernel32.dll", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kFSCatInfoNone, Type = Double, Dynamic = False, Default = \"&h00000000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kFSIterateFlat, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = TreeCountErrorValue, Type = Double, Dynamic = False, Default = \"-1", Scope = Private
	#tag EndConstant


	#tag Structure, Name = DIR, Flags = &h21
		dd_fd as Integer
		  dd_loc as Integer
		  dd_size as Integer
		  dd_buf as Ptr
		  dd_len as Integer
		  dd_seek as Integer
		  dd_rewind as Integer
		  dd_flags as Integer
		  dd_lock as Integer
		dd_td as Ptr
	#tag EndStructure

	#tag Structure, Name = dirent, Flags = &h21
		d_ino as UInt32
		  d_reclen as Int16
		  d_type as UInt8
		  d_namlen as UInt8
		d_name as String*256
	#tag EndStructure

	#tag Structure, Name = dirent64, Flags = &h21
		d_ino as UInt64
		  d_seekoff as UInt64
		  d_reclen as UInt16
		  d_namlen as UInt16
		  d_type as UInt8
		  d_name as String*1024
		  P(6) as UInt16
		P2(63) as UInt8
	#tag EndStructure

	#tag Structure, Name = FILETIME, Flags = &h21
		dwLowDateTime as Int32
		dwHighDateTime as Int32
	#tag EndStructure

	#tag Structure, Name = FSCatalogInfo, Flags = &h21
		nodeFlags as UInt16
		  volume as Int16
		  parentDirID as UInt32
		  nodeID as UInt32
		  sharingFlags as UInt8
		  userPrivileges as UInt8
		  reserved1 as UInt8
		  reserved2 as UInt8
		  createDate as UTCDateTime
		  contentModDate as UTCDateTime
		  attributeModDate as UTCDateTime
		  accessDate as UTCDateTime
		  backupDate as UTCDateTime
		  permissions(3) as UInt32
		  finderInfo(15) as UInt8
		  extFinderInfo(15) as UInt8
		  dataLogicalSize as UInt64
		  dataPhysicalSize as UInt64
		  rsrcLogicalSize as UInt64
		  rsrcPhysicalSize as UInt64
		  valence as UInt32
		textEncodingHint as UInt32
	#tag EndStructure

	#tag Structure, Name = FSRef, Flags = &h21
		hidden(79) as UInt8
	#tag EndStructure

	#tag Structure, Name = UTCDateTime, Flags = &h21
		highSeconds as UInt16
		  lowSeconds as UInt32
		fraction as UInt16
	#tag EndStructure

	#tag Structure, Name = WIN32_FIND_DATA, Flags = &h21
		dwFileAttributes as Integer
		  ftCreationTime as FILETIME
		  ftLastAccessTime as FILETIME
		  ftLastWriteTime as FILETIME
		  nFileSizeHigh as Int32
		  nFileSizeLow as Int32
		  dwReserved0 as Int32
		  dwReserved1 as Int32
		  cFileName(259) as Int8
		cAlternateFileName(13) as Int8
	#tag EndStructure


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
