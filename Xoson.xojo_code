#tag Module
Protected Module Xoson
	#tag Method, Flags = &h21
		Private Function arrayConverter(returnValue As Variant, elementType As Introspection.TypeInfo) As Auto()
		  'converts an Xojo array of any type into an JSON array JSONItem
		  '@param returnValue the array to convert
		  '@return the converted JSONItem, or Nil, if returnValue is not an array
		  
		  If Not returnValue.IsArray Then Return Nil
		  Dim ret() As Auto
		  
		  select case returnValue.ArrayElementType
		  case Variant.TypeString
		    dim v() as string = returnValue
		    for each element as string in v
		      ret.Append(element)
		    next
		    
		  case Variant.TypeInteger
		    dim v() as integer = returnValue
		    for each element as integer in v
		      ret.Append(element)
		    next
		    
		    
		  case Variant.TypeDouble
		    dim v() as double = returnValue
		    for each element as double in v
		      ret.Append(element)
		    next  
		    
		  case variant.TypeDate
		    dim v() as Date = returnValue
		    for each element as Date in v
		      ret.Append(convertDate(element))
		    next
		    
		  case Variant.TypeObject  
		    dim v() as object = returnValue
		    if elementType = GetTypeInfo(Date) then
		      for each element as Object in v
		        ret.Append(convertDate(Date(element)))
		      next
		    elseif elementType = GetTypeInfo(Xojo.Core.Date) then
		      for each element as Object in v
		        ret.Append(convertXojoDate(Xojo.Core.Date(element)))
		      next
		    else
		      for each element as object in v
		        ret.Append(element.toJSON())
		      next
		    end if
		    
		  case Variant.TypeBoolean
		    dim v() as boolean = returnValue
		    for each element as boolean in v
		      ret.Append(element)
		    next
		    
		  case variant.TypeSingle
		    dim v() as single = returnValue
		    for each element as single in v
		      ret.Append(element)
		    next
		    
		  case variant.TypeColor
		    dim v() as Color = returnValue
		    for each element as Color in v
		      ret.Append(element)
		    next
		    
		  case variant.TypeCurrency
		    dim v() as Currency = returnValue
		    for each element as Currency in v
		      ret.Append(element)
		    next
		    
		  case variant.TypeLong
		    dim v() as Int64 = returnValue
		    for each element as Int64 in v
		      ret.Append(element)
		    next
		    
		  case variant.TypePtr
		    dim v() as Ptr = returnValue
		    for each element as Ptr in v
		      ret.Append(element)
		    next
		    
		  end select
		  
		  Return ret
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub arrayParser(json() As Auto, ByRef returnValue As Variant, returnElementType As Xojo.Introspection.TypeInfo)
		  'parses a json array into a Xojo array of any type
		  '@param returnValue the array into which to parse. Must be of the type to parse
		  '@param returnElementType the type of array elements. Only necessary when array elements are objects
		  '@throws XosonException containing the error occured while parsing
		  
		  Dim returnType As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(returnValue)
		  
		  If Not returnType.IsArray Or Not returnValue.IsArray Then Raise New XosonException(ParseError.TypeNotMatching, "Expected array")
		  If returnType.ArrayRank > 1 then Raise New XosonException(ParseError.MultiDimArray, "Multi-dimensional arrays are not supported") 'feel free to implement
		  
		  Dim childCount As Integer = json.Ubound()
		  
		  select case returnValue.ArrayElementType
		  case Variant.TypeString
		    dim v() as string = returnValue
		    ReDim v(-1)  
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), String))
		      next    
		    catch exc As TypeMismatchException
		      'convert Text to String implicitly
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), Text))
		        next    
		      catch exc0 As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc0.message)
		      end try
		    end try
		    
		  case Variant.TypeText
		    dim v() as string = returnValue
		    ReDim v(-1)  
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), Text))
		      next    
		    catch exc As TypeMismatchException
		      'convert String to Text implicitly
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), String))
		        next    
		      catch exc0 As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc0.message)
		      end try
		    end try
		    
		  case Variant.TypeInteger
		    dim v() as integer = returnValue
		    ReDim v(-1)
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), Integer))
		      next    
		    catch exc As TypeMismatchException
		      Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		    end try
		    
		    
		  case Variant.TypeDouble
		    dim v() as double = returnValue
		    ReDim v(-1)
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), Double))
		      next    
		    catch exc As TypeMismatchException
		      Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		    end try
		    
		  case Variant.TypeObject
		    dim v() as object = returnValue  
		    ReDim v(-1)
		    
		    if returnElementType = GetTypeInfo(Date) then
		      try
		        for i As Integer = 0 to childCount
		          v.Append(parseDate(CType(json(i), Text)))
		        next    
		      catch exc As TypeMismatchException
		        'convert String to Text implicitly
		        try
		          for i As Integer = 0 to childCount
		            v.Append(parseDate(CType(json(i), String)))
		          next    
		        catch exc0 As TypeMismatchException
		          Raise New XosonException(ParseError.TypeNotMatching, exc0.message)
		        end try
		      end try
		      
		    elseif returnElementType = GetTypeInfo(Xojo.Core.Date) then
		      try
		        for i As Integer = 0 to childCount
		          v.Append(parseXojoDate(CType(json(i), Text)))
		        next    
		      catch exc As TypeMismatchException
		        'convert String to Text implicitly
		        try
		          for i As Integer = 0 to childCount
		            v.Append(parseXojoDate(CType(json(i), String)))
		          next    
		        catch exc0 As TypeMismatchException
		          Raise New XosonException(ParseError.TypeNotMatching, exc0.message)
		        end try
		      end try
		      
		    else
		      Dim cons As Xojo.Introspection.ConstructorInfo = getSimpleConstructor(returnElementType)
		      if cons = Nil then Raise New XosonException(ParseError.NoSimpleConstructor, "No constructor with 0 parameters for class " + returnElementType.Name)
		      
		      for i As Integer = 0 to childCount
		        Dim dict As Xojo.Core.Dictionary
		        try
		          dict = CType(json(i), Xojo.Core.Dictionary)
		        catch exc As TypeMismatchException
		          Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		        end try
		        Dim o As object
		        if dict = nil then
		          o = nil
		        else
		          o = cons.Invoke()    
		          o.fromJSON(dict)
		        end if
		        v.Append(o)
		      next
		      
		    end if
		    
		  case Variant.TypeBoolean
		    dim v() as boolean = returnValue
		    ReDim v(-1)
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), Boolean))
		      next    
		    catch exc As TypeMismatchException
		      Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		    end try
		    
		  case variant.TypeSingle
		    dim v() as single = returnValue
		    ReDim v(-1)
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), Single))
		      next    
		    catch exc As TypeMismatchException
		      Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		    end try
		    
		  case variant.TypeColor
		    dim v() as Color = returnValue
		    ReDim v(-1)
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), Color))
		      next    
		    catch exc As TypeMismatchException
		      Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		    end try
		    
		  case variant.TypeCurrency
		    dim v() as Currency = returnValue
		    ReDim v(-1)
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), Currency))
		      next    
		    catch exc As TypeMismatchException
		      Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		    end try
		    
		  case variant.TypeDate
		    dim v() as Date = returnValue
		    ReDim v(-1)
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), Date))
		      next    
		    catch exc As TypeMismatchException
		      Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		    end try
		    
		  case variant.TypeLong
		    dim v() as Int64 = returnValue
		    ReDim v(-1)
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), Int64))
		      next    
		    catch exc As TypeMismatchException
		      Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		    end try
		    
		  case variant.TypePtr
		    dim v() as Ptr = returnValue
		    ReDim v(-1)
		    try
		      for i As Integer = 0 to childCount
		        v.Append(CType(json(i), Ptr))
		      next    
		    catch exc As TypeMismatchException
		      Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		    end try
		    
		  case else
		    Raise New XosonException(ParseError.TypeUnknown, "Variant type "+ Str(returnValue.ArrayElementType) + " is not supported")
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function convertDate(d As Date) As String
		  Dim mb As New MemoryBlock(24)
		  mb.StringValue(0,4) = Format(d.Year, "0000")
		  mb.Byte(4) = &h2D
		  mb.StringValue(5,2) = Format(d.Month, "00")
		  mb.Byte(7) = &h2D
		  mb.StringValue(8,2) = Format(d.Day, "00")
		  mb.Byte(10) = &h54
		  mb.StringValue(11,2) = Format(d.Hour, "00")
		  mb.Byte(13) = &h3A
		  mb.StringValue(14,2) = Format(d.Minute, "00")
		  mb.Byte(16) = &h3A
		  mb.StringValue(17,2) = Format(d.Second, "00")
		  mb.Byte(19) = &h2E
		  mb.StringValue(20,3) = "000" 'milliseconds are not available in Date
		  mb.Byte(23) = &h5A
		  return DefineEncoding(mb.StringValue(0, 24), Encodings.UTF8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function convertXojoDate(d As Xojo.Core.Date) As String
		  Dim mb As New MemoryBlock(24)
		  mb.StringValue(0,4) = Format(d.Year, "0000")
		  mb.Byte(4) = &h2D
		  mb.StringValue(5,2) = Format(d.Month, "00")
		  mb.Byte(7) = &h2D
		  mb.StringValue(8,2) = Format(d.Day, "00")
		  mb.Byte(10) = &h54
		  mb.StringValue(11,2) = Format(d.Hour, "00")
		  mb.Byte(13) = &h3A
		  mb.StringValue(14,2) = Format(d.Minute, "00")
		  mb.Byte(16) = &h3A
		  mb.StringValue(17,2) = Format(d.Second, "00")
		  mb.Byte(19) = &h2E
		  mb.StringValue(20,3) = "000" 'milliseconds are not available in Date
		  mb.Byte(23) = &h5A
		  return DefineEncoding(mb.StringValue(0, 24), Encodings.UTF8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fromJSON(extends obj As Object, json As Xojo.Core.Dictionary)
		  'sets properties of obj to corresponding values from json object
		  '@param obj the object to parse values in
		  '@param json the deserialized JSON to parse (return value of Xojo.Data.ParseJSON)
		  '@throws NilObjectException if json is Nil or XosonException if parsing failed
		  
		  if json = Nil then Raise New NilObjectException
		  
		  Dim tp As String
		  Dim parameter As Variant
		  
		  Dim objTypeInfo As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(obj)
		  
		  'prepare Dictionary with (name : PropertyInfo) for fast access
		  Dim props() As Xojo.Introspection.PropertyInfo = objTypeInfo.Properties
		  Dim propsDict As New Xojo.Core.Dictionary
		  for each prop As Xojo.Introspection.PropertyInfo in props
		    if prop.canWrite and prop.isPublic and not prop.isShared then propsDict.Value(prop.Name) = prop
		  next
		  
		  for each entry as Xojo.Core.DictionaryEntry in json
		    Dim name As Text = entry.Key
		    Dim propertyInfo As Xojo.Introspection.PropertyInfo = propsDict.Lookup(name, Nil)
		    if propertyInfo = Nil then Continue
		    Dim propertyType As Xojo.Introspection.TypeInfo = propertyInfo.PropertyType
		    Dim childValue As Auto = entry.Value
		    Dim childType As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(childValue)
		    
		    if childValue = nil then
		      if propertyType.isClass then
		        propertyInfo.Value(obj) = nil
		      else
		        Raise New XosonException(ParseError.TypeNotMatching, "Property " + propertyInfo.Name + " is non-class but JSON child is null")
		      end if
		    elseif childType = GetTypeInfo(Xojo.Core.Dictionary) then
		      Dim childItem As Xojo.Core.Dictionary = Xojo.Core.Dictionary(childValue)
		      
		      if propertyType.isClass then
		        
		        if propertyInfo.Value(obj) = nil then
		          Dim cons As Xojo.Introspection.ConstructorInfo = getSimpleConstructor(propertyType)
		          if cons = Nil then Raise New XosonException(ParseError.NoSimpleConstructor, "No constructor with 0 parameters for class " + propertyType.Name)
		          
		          Dim member As object = cons.Invoke()
		          member.fromJSON(childItem)
		          propertyInfo.Value(obj) = member
		        else
		          CType(propertyInfo.Value(obj), Object).fromJSON(childItem)
		        end if
		        
		      elseif propertyType.isArray then
		        Raise New XosonException(ParseError.TypeNotMatching, "Property " + propertyInfo.Name + " is array but JSON child isn't")
		        
		      else
		        continue
		      end if
		      
		    elseif childType.IsArray then
		      if not propertyType.isArray then Raise New XosonException(ParseError.TypeNotMatching, "JSON child " + name + " is array but property isn't")
		      
		      Dim elementType As Xojo.Introspection.TypeInfo = propertyType.ArrayElementType()
		      Dim arrayProperty As Variant = propertyInfo.Value(obj)
		      arrayParser(childValue, arrayProperty, elementType)
		      
		    elseif childType = propertyType then
		      propertyInfo.Value(obj) = childValue    
		      
		    elseif childType = GetTypeInfo(Text) and propertyType = GetTypeInfo(String) _
		      or childType = GetTypeInfo(String) and propertyType = GetTypeInfo(Text) then 'convert Text and String to each other
		      propertyInfo.Value(obj) = childValue
		      
		    elseif childType = GetTypeInfo(Int32) and propertyType = GetTypeInfo(Int64) _
		      or childType = GetTypeInfo(Single) and propertyType = GetTypeInfo(Double) then 'if we have more bytes in our target field, it's not so bad
		      propertyInfo.Value(obj) = childValue
		      
		    elseif (propertyType = GetTypeInfo(Date) or propertyType = GetTypeInfo(Xojo.Core.Date)) _
		      and (childType = GetTypeInfo(Text) or childType = GetTypeInfo(String)) then
		      'Dim iso8601 As MemoryBlock
		      'if childType = GetTypeInfo(Text) then
		      'Dim tmp As String = CType(childValue, Text)
		      'iso8601 = tmp
		      'else
		      'iso8601 = CType(childValue, String)
		      'end if
		      
		      if propertyType = GetTypeInfo(Xojo.Core.Date) then
		        propertyInfo.Value(obj) = parseXojoDate(childValue)
		      else
		        propertyInfo.Value(obj) = parseDate(childValue)
		      end if
		      
		    end if
		    
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fromJSONText(extends obj As Object, json As Text)
		  '@see fromJSON(extends obj As Object, json As Xojo.Core.Dictionary)
		  '@throws additionally the InvalidJSONException, if json is not JSON-formatted
		  
		  obj.fromJSON(Xojo.Data.ParseJSON(json))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function getSimpleConstructor(elementType As Xojo.Introspection.TypeInfo) As Xojo.Introspection.ConstructorInfo
		  '@return a constructor with 0 parameters or nil if none available
		  
		  Dim cs() As Xojo.Introspection.ConstructorInfo = elementType.Constructors()
		  For each c As Xojo.Introspection.ConstructorInfo In cs
		    If c.Parameters().UBound() = -1 Then return c
		  Next
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function parseDate(stringRepresentation As String) As Date
		  
		  Dim d As New DateIntermediate(stringRepresentation)
		  
		  return New Date(d.year, d.month, d.day, d.hour, d.minute, d.second, 0.0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function parseXojoDate(stringRepresentation As String) As Xojo.Core.Date
		  
		  Dim d As New DateIntermediate(stringRepresentation)
		  
		  return New Xojo.Core.Date(d.year, d.month, d.day, d.hour, d.minute, d.second, new Xojo.Core.TimeZone(0))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function toJSON(extends obj As Object) As Xojo.Core.Dictionary
		  'converts an Xojo object of any type into a dictionary to be used by Xojo.Data.GenerateJSON()
		  '@param obj the object to serialize. All publicly readable, non-shared properties are considered.
		  '@return the JSON
		  
		  Dim ret As New Xojo.Core.Dictionary()
		  
		  Dim tpInfo As Introspection.TypeInfo = Introspection.GetType(obj)
		  While tpInfo <> Nil
		    
		    Dim props() As Introspection.PropertyInfo = tpInfo.GetProperties()
		    For each prop As Introspection.PropertyInfo In props
		      If not prop.IsPublic or not prop.CanRead Then Continue
		      
		      if prop.Value(obj).IsNull then
		        ret.Value(prop.Name) = nil
		      elseif prop.PropertyType.isClass then
		        if prop.PropertyType = GetTypeInfo(Date) then
		          ret.Value(prop.Name) = convertDate(prop.Value(obj))
		        elseif prop.PropertyType = GetTypeInfo(Xojo.Core.Date) then
		          ret.Value(prop.Name) = convertXojoDate(prop.Value(obj))
		        else
		          ret.Value(prop.Name) = CType(prop.Value(obj), Object).toJSON()
		        end if
		      elseif prop.PropertyType = GetTypeInfo(String) then
		        ret.Value(prop.Name) = ConvertEncoding(prop.Value(obj).StringValue, Encodings.UTF8)
		        
		      elseif prop.PropertyType.isArray then
		        ret.Value(prop.Name) = arrayConverter(prop.Value(obj), prop.PropertyType.GetElementType())
		        
		      else
		        ret.Value(prop.Name) = prop.Value(obj)
		        
		      end if
		      
		    Next
		    
		    tpInfo = tpInfo.BaseType
		  Wend
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function toJSONText(extends obj As Object) As Text
		  Dim dict As Xojo.Core.Dictionary = obj.toJSON()
		  return Xojo.Data.GenerateJSON(dict)
		End Function
	#tag EndMethod


	#tag Enum, Name = ParseError, Type = Integer, Flags = &h1
		NoError
		  TypeNotMatching
		  NoSimpleConstructor
		  TypeUnknown
		MultiDimArray
	#tag EndEnum


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
	#tag EndViewBehavior
End Module
#tag EndModule
