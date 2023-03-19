#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  #Pragma Unused args
		  'Xojo JSON serialization example
		  
		  Print("/*** 0. Serialize this sample object: ****/")
		  
		  Dim serializable As New Sample
		  serializable.decimalNumber = 10.0
		  serializable.regularDate = new Date()
		  serializable.Message = "These violent delights have violent ends"
		  serializable.tm.Append(Xojo.Core.Date.Now)
		  
		  serializable.describe()
		  
		  Print("/*** 1. The sample object serialized to JSON: ***/")
		  
		  Dim serialization As Text = Xoson.toJSON(serializable)
		  
		  Print(serialization)
		  Print(EndOfLine)
		  
		  
		  Print("/*** 2. Now change the object's properties to demonstrate that they are overridden when deserializing: ***/")
		  
		  serializable.regularDate = nil
		  serializable.Message = "And in their triump die, like fire and powder Which, as they kiss, consume"
		  serializable.decimalNumber = 4.2
		  serializable.test = true
		  serializable.optionalBool = true
		  serializable.baseProperty = 1337
		  
		  serializable.describe()
		  
		  Print("/*** 3. Now parse the JSON we generated in 1. The output is the same as in step 0: ***/")
		  
		  Xoson.fromJSON(serializable, serialization)
		  
		  serializable.describe()
		  
		  Dim serializableArray() As Sample
		  serializableArray.Append(serializable)
		  
		  Print("/*** 4. Demonstrate array serialization: ***/")
		  print(Xoson.toJSON(serializableArray))
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
