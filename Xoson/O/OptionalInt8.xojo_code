#tag Class
Protected Class OptionalInt8
Inherits Xoson.O.OptionalPrimitive
	#tag Method, Flags = &h0
		Function Operator_Convert() As Int8
		  Return Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Convert(rhs As Int8)
		  Value = rhs
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(Assigns rhs As Int8)
		  Value = rhs
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return Value.ToString
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Value As Int8
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Int8"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
