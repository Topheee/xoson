#tag Class
Protected Class DateIntermediate
	#tag Method, Flags = &h0
		Sub Constructor(rfc3339Representation As String)
		  'Parses RFC 3339 dates. Thanks to https://ijmacd.github.io/rfc3339-iso8601/ - consult this if you want to add iso8601 support.
		  'We cannot use sscanf() due to lack of support for variadic functions; and it would reduce portability.
		  
		  Dim rfc3339 As MemoryBlock = rfc3339Representation
		  Dim countInt As Integer = rfc3339.Size - 1
		  If countInt < 9 Then Raise New XosonException(ParseError.TypeNotMatching, "Failed to parse '" + rfc3339Representation + "' as an RFC 3339 date.")
		  If countInt > 127 Then Raise New XosonException(ParseError.InternalError, "Failed to parse '" + rfc3339Representation + "' as an RFC 3339 date, since it is longer than 127 characters.")
		  Dim count As Int8 = countInt
		  
		  Dim expectedChars(5), expectedOffsets(5) As Int8
		  expectedOffsets(0) = 4
		  expectedOffsets(1) = 7
		  expectedOffsets(2) = 10
		  expectedOffsets(3) = 13
		  expectedOffsets(4) = 16
		  'we do not expect a specific char here, we just need to be higher than 18
		  expectedOffsets(5) = 19
		  expectedChars(0) = &h2D
		  expectedChars(1) = &h2D
		  expectedChars(2) = &h54
		  expectedChars(3) = &h3A
		  expectedChars(4) = &h3A
		  'we do not expect a specific char here, we just need to provide a value
		  expectedChars(5) = 0
		  
		  Dim indexExpected As Int8 = 0
		  Dim fixedCharacterEnd As Int8 = Min(count, 18)
		  For i As Int8 = 0 To fixedCharacterEnd
		    If i < expectedOffsets(indexExpected) Then
		      If rfc3339.Byte(i) < &h30 Or rfc3339.Byte(i) > &h39 Then _
		      Raise New XosonException(ParseError.TypeNotMatching, "Failed to parse '" + rfc3339Representation + "' as an RFC 3339 date.")
		    Else
		      'we ignore the character at index 10 (usually a "T", but the spec seems to be blurry)
		      If rfc3339.Byte(i) <> expectedChars(indexExpected) And i <> 10 Then _
		      Raise New XosonException(ParseError.TypeNotMatching, "Failed to parse '" + rfc3339Representation + "' as an RFC 3339 date.")
		      indexExpected = indexExpected + 1
		    End If
		  Next
		  
		  'Parse Date
		  
		  Year = Val(rfc3339.StringValue(0, 4))
		  Month = Val(rfc3339.StringValue(5, 2))
		  Day = Val(rfc3339.StringValue(8, 2))
		  
		  If countInt = 9 Then Return

		  'Parse Time
		  
		  If countInt < 19 Then Raise New XosonException(ParseError.TypeNotMatching, "Failed to parse '" + rfc3339Representation + "' as an RFC 3339 datetime.")
		  
		  Hour = Val(rfc3339.StringValue(11, 2))
		  Minute = Val(rfc3339.StringValue(14, 2))
		  Second = Val(rfc3339.StringValue(17, 2))
		  
		  'Parse Milliseconds
		  
		  Dim offset As Int8 = 19
		  If rfc3339.Byte(offset) = &h2E Then
		    offset = offset + 1
		    While offset < count And rfc3339.Byte(offset) > &h2F And rfc3339.Byte(offset) < &h3A
		      offset = offset + 1
		    Wend
		    
		    If offset = 20 Then Raise New XosonException(ParseError.TypeNotMatching, "Failed to parse '" + rfc3339Representation + "' as an RFC 3339 datetime.")
		    'We do not support sub-millisecond precision.
		    Millisecond = Val(rfc3339.StringValue(20, Min(offset-20, 3)))
		  End If
		  
		  'Parse Timezone
		  
		  Dim isMinusOffset As Boolean = False
		  
		  If rfc3339.Byte(offset) = &h5A Then
		    'UTC
		    ZoneOffsetMinutes = 0
		    Return
		  ElseIf rfc3339.Byte(offset) = &h2D Then
		    isMinusOffset = True
		  ElseIf rfc3339.Byte(offset) <> &h2B Then
		    Raise New XosonException(ParseError.TypeNotMatching, "Failed to parse '" + rfc3339Representation + "' as an RFC 3339 datetime.")
		  End If
		  
		  If offset + 5 > count Or _
		    rfc3339.Byte(offset + 1) < &h30 Or rfc3339.Byte(offset + 1) > &h39 Or _
		    rfc3339.Byte(offset + 2) < &h30 Or rfc3339.Byte(offset + 2) > &h39 Or _
		    rfc3339.Byte(offset + 3) <> &h3A Or _
		    rfc3339.Byte(offset + 4) < &h30 Or rfc3339.Byte(offset + 4) > &h39 Or _
		    rfc3339.Byte(offset + 5) < &h30 Or rfc3339.Byte(offset + 5) > &h39 Then _
		    Raise New XosonException(ParseError.TypeNotMatching, "Failed to parse '" + rfc3339Representation + "' as an RFC 3339 datetime.")
		  
		  ZoneOffsetMinutes = Val(rfc3339.StringValue(offset + 1, 2)) * 24
		  ZoneOffsetMinutes = ZoneOffsetMinutes + Val(rfc3339.StringValue(offset + 4, 2))
		End Sub
	#tag EndMethod


	#tag Note, Name = Info
		
		Helper class representing the common properties between Date and Xojo.Core.Date for a shared parsing implementation.
	#tag EndNote


	#tag Property, Flags = &h0
		Day As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Hour As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Millisecond As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Minute As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Month As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Second As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Year As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ZoneOffsetMinutes As Integer
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
