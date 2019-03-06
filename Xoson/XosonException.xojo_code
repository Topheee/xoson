#tag Class
Protected Class XosonException
Inherits RuntimeException
	#tag Method, Flags = &h0
		Sub Constructor(parseError As Xoson.ParseError, message As String)
		  ErrorNumber = Integer(parseError)
		  me.Message = "XosonException: " + message
		End Sub
	#tag EndMethod


End Class
#tag EndClass
