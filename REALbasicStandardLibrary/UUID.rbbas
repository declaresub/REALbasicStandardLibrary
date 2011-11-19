#tag Class
Protected Class UUID
	#tag Method, Flags = &h0
		Sub Constructor()
		  //creates a fresh, new v4 UUID.
		  self.uuidData = Generate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(uuidData as MemoryBlock)
		  //creates UUID by copying data from uuidData.  I don't check uuidData.Size since a MemoryBlock
		  //obtained from some other external function could
		  //have size = -1.  So it's up to you to practice safe computing.
		  
		  #if targetMacOS or targetLinux
		    declare sub uuid_copy lib libuuid (dst as Ptr, src as Ptr)
		    
		    dim dst as new MemoryBlock(uuidSize)
		    uuid_copy(dst, uuidData)
		    self.uuidData = dst
		  #endif
		  
		  #if targetWin32
		    //there doesn't appear to be a Windows function corresponding to uuid_copy.  So
		    //I just copy the data.
		    
		    self.uuidData = uuidData.LeftB(uuidSize)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(theUUID as UUID)
		  if theUUID is nil then
		    dim e as new NilObjectException
		    e.Message = CurrentMethodName + ": theUUID cannot be nil."
		    raise e
		  end if
		  
		  self.Constructor(theUUID.uuidData)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Data() As String
		  return self.uuidData.LeftB(self.uuidData.Size)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function Generate() As MemoryBlock
		  #if targetMacOS or targetLinux
		    soft declare sub uuid_generate lib libuuid (out as Ptr)
		    
		    dim data as MemoryBlock = Newuuidbytes
		    uuid_generate data
		    return data
		  #endif
		  
		  #if targetWin32
		    soft declare function UuidCreate lib win32.Rpcrt4 (Uuid as Ptr) as Integer
		    dim m as MemoryBlock = NewUUIDBytes
		    dim err as Integer = UuidCreate(m)
		    if err = Win32Error.RPC_S_OK then
		      return m
		    else
		      //probably should raise a win32 exception.
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GenerateTime() As String
		  #if targetMacOS or targetLinux
		    soft declare sub uuid_generate_time lib libuuid (out as Ptr)
		    
		    dim data as MemoryBlock = Newuuidbytes
		    uuid_generate_time data
		    return data
		  #endif
		  
		  #if targetWin32
		    soft declare function UuidCreateSequential lib win32.Rpcrt4 (Uuid as Ptr) as Integer
		    dim m as new MemoryBlock(uuidSize)
		    dim err as Integer = UuidCreateSequential(m)
		    if err = Win32Error.RPC_S_OK then
		      return m
		    else
		      //?
		    end if
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function NewUUID(theuuid as UUID) As UUID
		  dim u as new UUID
		  u.uuidData = theuuid.uuidData
		  return u
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function Newuuidbytes() As MemoryBlock
		  // uuidbytes is the struct used to represent a uuid.
		  //I'm using a MemoryBlock instead of a structure because
		  //uuidbytes is nothing more than 16 bytes of Uint8, and
		  //using a MemoryBlock allows me to use a single class and
		  //be backward-compatible to 2007 r2 or so.
		  
		  return new MemoryBlock(uuidSize)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function NewUUIDV1() As UUID
		  dim u as new UUID
		  u.uuidData = GenerateTime
		  return u
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function NewUUIDV4() As UUID
		  return new UUID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(u2 as UUID) As Integer
		  #if targetMacOS or targetLinux
		    soft declare function uuid_compare lib libuuid (uu1 as Ptr, uu2 as Ptr) as Integer
		    
		    return uuid_compare(self.uuidData, u2.uuidData)
		  #endif
		  
		  #if targetWin32
		    soft declare function UuidCompare lib win32.Rpcrt4 (Uuid1 as Ptr, Uuid2 as Ptr, ByRef status as Integer) as Integer
		    
		    dim result as Integer
		    dim cmp as Integer = UuidCompare(self.uuidData, u2.uuidData, result)
		    if result = Win32Error.RPC_S_OK then
		      return cmp
		    else
		      //raise Win32Error?
		    end if
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Convert() As String
		  #if targetMacOS or targetLinux
		    soft declare sub uuid_unparse lib libuuid (u as CString, out as Ptr)
		    
		    dim m as new MemoryBlock(37)
		    uuid_unparse self.uuidData, m
		    return DefineEncoding(m.CString(0), Encodings.ASCII)
		  #endif
		  
		  #if targetWin32
		    soft declare function UuidToStringA lib win32.Rpcrt4 (Uuid as CString, ByRef StringUuid as Ptr) as Integer
		    
		    dim stringuuid as Ptr
		    dim value as String
		    dim err as Integer = UuidToStringA(self.uuidData, stringuuid)
		    if err = 0 then
		      try
		        dim m as MemoryBlock = stringuuid
		        value = DefineEncoding(m.CString(0), Encodings.ASCII)
		      finally
		        soft declare function RpcStringFreeA lib win32.Rpcrt4 (ByRef p as Ptr) as Integer
		        dim freeErr as Integer = RpcStringFreeA(stringuuid)
		      end try
		    else
		      //
		    end if
		    return value
		  #endif
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Convert(value as String)
		  if value.Encoding <> nil then
		    value = ConvertEncoding(value, Encodings.ASCII)
		  end if
		  
		  #if targetMacOS or targetLinux
		    soft declare function uuid_parse lib libuuid (inValue as CString, uu as Ptr) as Integer
		    
		    dim bytes as MemoryBlock = Newuuidbytes
		    if uuid_parse(value, bytes) = 0 then
		      self.uuidData = bytes
		    else
		      raise UnableToParseException(value)
		    end if
		    
		  #endif
		  
		  #if targetWin32
		    soft declare function UuidFromStringA lib win32.Rpcrt4 (StringUuid as CString, uuid as Ptr) as Integer
		    
		    dim data as new MemoryBlock(16)
		    dim err as Integer = UuidFromStringA(value, data)
		    if err = 0 then
		      self.uuidData = data
		    else
		      raise UnableToParseException(value)
		    end if
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_CopyConstructor()
		  dim testUUID as new UUID
		  dim uuidCopy as new UUID(testUUID)
		  testUUID.Operator_Compare(uuidCopy).ShouldEqual 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Test_Operator_Compare_Equal()
		  const TestValue1 = "04DD7692-BB6A-4860-9307-A137F464587A"
		  const TestValue2 = "04DD7692-BB6A-4860-9307-A137F464587A"
		  
		  dim uuid1 as UUID = TestValue1
		  dim uuid2 as UUID = TestValue2
		  
		  uuid2.Operator_Compare(uuid1).ShouldEqual 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Test_Operator_Compare_GreaterThan()
		  const TestValue1 = "04DD7692-BB6A-4860-9307-A137F464587A"
		  const TestValue2 = "D0D48EC1-9C45-4B17-801C-8EFB6E11D6BF"
		  
		  dim uuid1 as UUID = TestValue1
		  dim uuid2 as UUID = TestValue2
		  
		  uuid2.Operator_Compare(uuid1).ShouldBeGreaterThan 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Test_Operator_Compare_LessThan()
		  const TestValue1 = "04DD7692-BB6A-4860-9307-A137F464587A"
		  const TestValue2 = "D0D48EC1-9C45-4B17-801C-8EFB6E11D6BF"
		  
		  dim uuid1 as UUID = TestValue1
		  dim uuid2 as UUID = TestValue2
		  
		  uuid1.Operator_Compare(uuid2).ShouldBeLessThan 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_Operator_Convert()
		  const testValue = "B134FAB9-4E0A-4F49-A39C-655553704502"
		  dim testUUID as UUID = testValue
		  dim stringValue as String = testUUID
		  stringValue.ShouldEqual testValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function UnableToParseException(value as String) As UnsupportedFormatException
		  dim e as new UnsupportedFormatException
		  e.Message = "Unable to parse '" + value + "' into a UUID."
		  return e
		End Function
	#tag EndMethod


	#tag Note, Name = ReadMe
		UUID is a class that represents UUIDs as immutable objects.
		
		
		
		UUID Creation
		
		Create a new (Version 4) UUID that no one else should have:
		
		dim u as new UUID
		
		Create a new version 1 UUID:
		
		dim u as new UUID = UUID.NewUUIDv1
		
		NewUUIDV1 returns a UUID based on a MAC address and timestamp.  For some situations, the use of a version 1 UUID might be considered a security risk.
		
		Create a new version 4 UUID:
		
		dim u as new UUID = UUID.NewUUIDv4
		
		Create a UUID from a MemoryBlock containing UUID data:
		
		dim u as new UUID(data)
		
		Create a new copy:
		
		dim u as new UUID(existingUUIDObject)
		
		Create a UUID object from a string:
		
		dim u as UUID = "1b4e28ba-2fa1-11d2-883f-b9a76"
		
		
		
		//UUID Manipulation
		
		Get a formatted string:
		
		dim s as String = theUUID
		
		Get raw data (note that this returns a copy of the object data):
		
		dim bytes as MemoryBlock = theUUID.Data
		
		
		An Operator_Compare function allows for comparision of UUID objects by lexicographic order.
	#tag EndNote


	#tag Property, Flags = &h21
		Private uuidData As MemoryBlock
	#tag EndProperty


	#tag Constant, Name = libc, Type = String, Dynamic = False, Default = \"", Scope = Private
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"libc.dylib"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"libc.so"
	#tag EndConstant

	#tag Constant, Name = libuuid, Type = String, Dynamic = False, Default = \"/lib/libuuid.so.1", Scope = Private
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"/lib/libuuid.so.1"
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"System.framework"
	#tag EndConstant

	#tag Constant, Name = uuidSize, Type = Double, Dynamic = False, Default = \"16", Scope = Private
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
