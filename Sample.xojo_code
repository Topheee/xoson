#tag Class
Protected Class Sample
Inherits SampleBase
	#tag Method, Flags = &h0
		Sub describe()
		  Print("Sample:")
		  Print("baseProperty: " + Str(baseProperty))
		  Print("decimalNumber: " + Str(decimalNumber))
		  Print("message: " + message)
		  if regularDate <> nil then Print("regularDate: " + regularDate.LongDate + " " + regularDate.LongTime + " GMT " + Str(regularDate.GMToffset))
		  Print("test: " + Str(test))
		  Dim optionalBoolStr As String
		  If optionalBool = Nil Then
		    optionalBoolStr = "Nil"
		  ElseIf optionalBool Then
		    optionalBoolStr = "True"
		  Else
		    optionalBoolStr = "False"
		  End If
		  Print("optionalBool: " + optionalBoolStr)
		  Print("tm: ")
		  for each t as Xojo.Core.Date in tm
		    Print("> " + t.toText(Xojo.Core.Locale.Current, Xojo.Core.Date.FormatStyles.Full, Xojo.Core.Date.FormatStyles.Full))
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
		optionalBool As Xoson.O.OptionalBoolean
	#tag EndProperty

	#tag Property, Flags = &h0
		regularDate As Date
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
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="message"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="decimalNumber"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="regularDate"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="test"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
