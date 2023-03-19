#tag Class
Private Class DateIntermediate
	#tag Method, Flags = &h0
		Sub Constructor(stringRepresentation As String)
		  'no bullet-proof parsing, but as we cannot use sscanf(), due to lack of support for variadic functions, this need to suffice
		  
		  Dim iso8601 As MemoryBlock = stringRepresentation
		  if iso8601.Size < 24 then Raise New XosonException(ParseError.TypeNotMatching, "Failed to parse '" + stringRepresentation + "' as a date")
		  
		  Dim expectedChars(6), expectedOffsets(6) As Int8
		  expectedOffsets(0) = 4
		  expectedOffsets(1) = 7
		  expectedOffsets(2) = 10
		  expectedOffsets(3) = 13
		  expectedOffsets(4) = 16
		  expectedOffsets(5) = 19
		  expectedOffsets(6) = 23
		  expectedChars(0) = &h2D
		  expectedChars(1) = &h2D
		  expectedChars(2) = &h54
		  expectedChars(3) = &h3A
		  expectedChars(4) = &h3A
		  expectedChars(5) = &h2E
		  expectedChars(6) = &h5A
		  Dim indexExpected As Integer = 0
		  Dim c As Integer = iso8601.Size - 1
		  for i As Integer = 0 To c
		    if i < expectedOffsets(indexExpected) then
		      if iso8601.Byte(i) < &h30 or iso8601.Byte(i) > &h39 then _
		      Raise New XosonException(ParseError.TypeNotMatching, "Failed to parse '" + stringRepresentation + "' as a date")
		    else
		      if iso8601.Byte(i) <> expectedChars(indexExpected) then _
		      Raise New XosonException(ParseError.TypeNotMatching, "Failed to parse '" + stringRepresentation + "' as a date")
		      indexExpected = indexExpected + 1
		    end if
		  next
		  
		  year = Val(iso8601.StringValue(0,4))
		  month = Val(iso8601.StringValue(5,2))
		  day = Val(iso8601.StringValue(8,2))
		  hour = Val(iso8601.StringValue(11,2))
		  minute = Val(iso8601.StringValue(14,2))
		  second = Val(iso8601.StringValue(17,2))
		  millisecond = Val(iso8601.StringValue(20,3))
		End Sub
	#tag EndMethod


	#tag Note, Name = Info
		
		Helper class representing the common properties between Date and Xojo.Core.Date for a shared parsing implementation.
	#tag EndNote


	#tag Property, Flags = &h0
		day As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		hour As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		millisecond As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		minute As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		month As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		second As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		year As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="day"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="hour"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="minute"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="month"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="second"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="year"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="millisecond"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
