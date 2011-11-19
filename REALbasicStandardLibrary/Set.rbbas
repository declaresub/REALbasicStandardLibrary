#tag Class
Protected Class Set
	#tag Method, Flags = &h0
		Sub Add(element as Variant)
		  self.Map.Value(element) = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(paramArray elements() as Variant)
		  self.Map = new Dictionary
		  
		  for each element as Variant in elements
		    self.Map.Value(element) = nil
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Contains(element as Variant) As Boolean
		  return self.Map.HasKey(element)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Copy() As Set
		  //returns a new Set containing the same elements.
		  
		  dim d as new Dictionary
		  for each key as Variant in self.map.Keys
		    d.Value(key) = nil
		  next
		  dim T as new Set
		  t.Map = d
		  return T
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Difference(T() as Set) As Set
		  dim U as Set = self
		  for each item as Set in T
		    U = U - item
		  next
		  return U
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Difference(ParamArray T() as Set) As Set
		  return self.Difference(T)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Equals(T as Set) As Boolean
		  if T <> nil then
		    dim SequalsT as Boolean = (self.Count <= T.Count)
		    if SequalsT then
		      for each element as Variant in self.Map.Keys
		        if not T.Map.HasKey(element) then
		          SequalsT = false
		          exit
		        end if
		      next
		    else
		      //S ⊄ T
		    end if
		    return SequalsT
		  else
		    return (self.Count = 0)
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Intersection(ParamArray T() as Set) As Set
		  return self.Intersection(T)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Intersection(T() as Set) As Set
		  //first I assemble all sets in a new local array.  If any has count 0 or is nil, the
		  //intersection will be empty, so we exit early.
		  //We also collect the size of each set for later use.
		  
		  if self.Count = 0 then
		    return new Set()
		  end if
		  
		  dim S() as Set
		  dim elementCount() as Integer
		  S.Append self
		  elementCount.Append self.Count
		  for each argument as Set in T
		    if argument <> nil then
		      S.Append argument
		      elementCount.Append argument.Count
		    else
		      return new Set()
		    end if
		  next
		  
		  //Now, the algorithm is to take one set S, and check to see whether each of its elements is in
		  //every other set.  We sort S by count, and use the elements of the smallest set to build the intersection.
		  
		  elementCount.SortWith S
		  
		  
		  dim A as Set = S(0)
		  dim B() as Set
		  for i as Integer = 1 to UBound(S)
		    B.Append S(i)
		  next
		  
		  dim d as new Dictionary
		  
		  for each element as Variant in A.Map.Keys
		    dim isInIntersection as Boolean = true
		    for each argument as Set in B
		      if not argument.Map.HasKey(element) then
		        isInIntersection = false
		        exit
		      end if
		    next
		    if isInIntersection then
		      d.Value(element) = nil
		    end if
		  next
		  
		  dim U as new Set
		  U.Map = d
		  return U
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_And(T as Set) As Set
		  return self.Intersection(T)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(T as Set) As Integer
		  if self.Equals(T) then
		    return 0
		  else
		    return 1
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Or(T as Set) As Set
		  return self.Union(T)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subtract(T as Set) As Set
		  //S - T returns a Set consisting of elements in S but not in T.
		  
		  dim d as new Dictionary
		  for each element as Variant in self.Map.Keys
		    if not T.Map.HasKey(element) then
		      d.Value(element) = nil
		    end if
		  next
		  
		  dim U as new Set
		  U.Map = d
		  return U
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Xor(T as Set) As Set
		  return self.Symmetric_DIfference(T)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(element as Variant)
		  self.Map.Remove element
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SubsetOf(T as Set) As Boolean
		  if T <> nil then
		    dim theAnswer as Boolean = true
		    for each element as Variant in self.Map.Keys
		      if not T.Map.HasKey(element) then
		        theAnswer = false
		        exit
		      end if
		    next
		    return theAnswer
		  else
		    return false
		  end If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SupersetOf(T as Set) As Boolean
		  return T = nil or T.SubsetOf(self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Symmetric_DIfference(T as Set) As Set
		  if T = nil then
		    T = new Set()
		  end if
		  
		  dim d as new Dictionary
		  
		  for each element as Variant in self.Map.Keys
		    if not T.Map.HasKey(element) then
		      d.Value(element) = nil
		    end if
		  next
		  for each element as Variant in T.Map.Keys
		    if not self.Map.HasKey(element) then
		      d.Value(element) = nil
		    end if
		  next
		  
		  dim U as new Set
		  U.Map = d
		  return U
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub TestEquals_EmptySet_Nil()
		  dim S as new Set()
		  S.Equals(nil).ShouldEqual true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub TestSubsetOfNil()
		  dim S as new Set("foo")
		  dim T as Set = nil
		  S.SubsetOf(T).ShouldEqual false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_Compare_Incomparable()
		  dim S as new Set(1)
		  dim T as new Set(2)
		  
		  'dim S_Contains_T as Boolean = S > T
		  'S_Contains_T.ShouldEqual false
		  
		  'dim T_Contains_S as Boolean =  S < T
		  'T_Contains_S.ShouldEqual false
		  
		  dim S_Equals_T as Boolean = S = T
		  S_Equals_T.ShouldEqual false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_Constructor()
		  dim S as new Set
		  #pragma nilObjectChecking false
		  S.Map.ShouldNotBe nil
		  #pragma nilObjectChecking true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_Equals()
		  dim S as new Set(1, 2, 3, 4)
		  dim T as new Set(1, 2, 3, 4)
		  S.Equals(T).ShouldEqual true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_Intersection_self()
		  dim S as new Set(2, 3, 5, 7, 11, 19, 23, 29)
		  S.Intersection(S).Equals(S).ShouldEqual true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_Intersection_TwoArgs()
		  dim S as new Set(1, 2, 3, 4)
		  dim T as new Set(1, 5, 6)
		  dim U as new Set(1, 7, 8, 9)
		  
		  S.Intersection(T, U).Equals(new Set(1)).ShouldEqual true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_NotEquals()
		  dim S as new Set(1)
		  dim T as new Set(2)
		  S.Equals(T).ShouldEqual false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_Operator_Subtract()
		  dim S as new Set(1, 2, 3)
		  dim T as new Set(2, 3)
		  dim U as Set = S - T
		  U.Equals(new Set(1)).ShouldEqual true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_SupersetOfNIl()
		  dim S as new Set("foo")
		  dim T as Set = nil
		  S.SupersetOf(T).ShouldEqual true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub Test_Union()
		  dim S as new Set(1, 2, 3, 4)
		  dim T as new Set(3, 4, 5, 6)
		  dim U as Set = S or T
		  U.Equals(new Set(1, 2, 3, 4, 5, 6)).ShouldEqual true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Union(T() as Set) As Set
		  dim d as new Dictionary
		  for each element as Variant in self.Map.Keys
		    d.Value(element) = nil
		  next
		  
		  for each item as Set in T
		    for each element as Variant in item.Map.Keys
		      d.Value(element) = nil
		    next
		  next
		  
		  dim U as new Set
		  U.Map = d
		  return U
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Union(ParamArray T() as Set) As Set
		  return self.Union(T)
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.Map.Count
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Map As Dictionary
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Count"
			Group="Behavior"
			Type="Integer"
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
