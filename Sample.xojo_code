#tag Class
Protected Class Sample
	#tag Method, Flags = &h0
		Sub describe()
		  Print("Sample:")
		  Print("decimalNumber: " + Str(decimalNumber))
		  Print("message: " + message)
		  Print("number: " + Str(number))
		  Print("test: " + Str(test))
		  Print("tm: ")
		  for each t as Xojo.Core.Date in tm
		    Print("> " + t.toText())
		  next
		  Print(EndOfLine)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		decimalNumber As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		message As String
	#tag EndProperty

	#tag Property, Flags = &h0
		number As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		test As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		tm() As Xojo.Core.Date
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="message"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="decimalNumber"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="number"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="test"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
