#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  'Xojo JSON serialization example
		  
		  Dim serializable As New Sample
		  serializable.decimalNumber = 10.0
		  serializable.number = 1
		  serializable.Message = "These violent delights have violent ends"
		  serializable.tm.Append(Xojo.Core.Date.Now)
		  
		  Dim serialization As Text = serializable.toJSONText()
		  
		  Print("/* JSON Serialization */")
		  Print(serialization)
		  Print(EndOfLine)
		  
		  serializable.number = 30
		  serializable.Message = "And in their triump die, like fire and powder Which, as they kiss, consume"
		  serializable.decimalNumber = 4.2
		  serializable.test = true
		  
		  Print("/* Local modification */")
		  serializable.describe()
		  
		  serializable.fromJSONText(serialization)
		  
		  Print("/* Values from previous JSON */")
		  serializable.describe()
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
