#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  #Pragma Unused args
		  'Xojo JSON serialization example
		  
		  Dim serializable As New Sample
		  serializable.decimalNumber = 10.0
		  serializable.number = 1
		  serializable.Message = "These violent delights have violent ends"
		  serializable.tm.Append(Xojo.Core.Date.Now)
		  
		  Dim serialization As Text = Xoson.toJSON(serializable)
		  
		  Print("/* JSON Serialization */")
		  Print(serialization)
		  Print(EndOfLine)
		  
		  serializable.number = 30
		  serializable.Message = "And in their triump die, like fire and powder Which, as they kiss, consume"
		  serializable.decimalNumber = 4.2
		  serializable.test = true
		  
		  Print("/* JSON Deserialization */")
		  serializable.describe()
		  
		  Xoson.fromJSON(serializable, serialization)
		  
		  Print("/* Values from previous JSON */")
		  serializable.describe()
		  
		  Dim serializableArray() As Sample
		  serializableArray.Append(serializable)
		  
		  Print("/* JSON Array Serialization */")
		  print(Xoson.toJSON(serializableArray))
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
