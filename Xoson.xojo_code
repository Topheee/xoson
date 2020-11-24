#tag Module
Protected Module Xoson
	#tag Method, Flags = &h21
		Private Function arrayConverter(returnValue As Auto, returnElementType As Xojo.Introspection.TypeInfo) As Auto()
		  'converts an Xojo array of any type into an JSON array JSONItem
		  '@param returnValue the array to convert
		  '@return the converted JSONItem, or Nil, if returnValue is not an array
		  
		  Dim ret() As Auto
		  
		  Dim typeName As String = returnElementType.FullName
		  if returnElementType.IsInterface or returnElementType.IsEnum or returnElementType.IsPointer then
		    Raise New XosonException(ParseError.UnsupportedType, "The type " + returnElementType.FullName + " is not serializable.")
		    
		  elseif returnElementType.IsClass or typeName = "Object" then 'Odd: class array's element types have IsClass set to false, but "Object" as name...
		    dim v() as object = returnValue
		    if typeName = "Date" then
		      for each element as Object in v
		        ret.Append(convertDate(Date(element)))
		      next
		    elseif typeName = "Xojo.Core.Date" then
		      for each element as Object in v
		        ret.Append(convertXojoDate(Xojo.Core.Date(element)))
		      next
		    else
		      for each element as object in v
		        ret.Append(toJSONImpl(element))
		      next
		    end if
		    
		  elseif returnElementType.IsPrimitive then
		    select case typeName
		    case "String"
		      dim v() as string = returnValue
		      for each element as string in v
		        ret.Append(element)
		      next
		      
		    case "Text"
		      dim v() as Text = returnValue
		      for each element as Text in v
		        ret.Append(element)
		      next
		      
		    case "Integer"
		      dim v() as integer = returnValue
		      for each element as integer in v
		        ret.Append(element)
		      next
		      
		    case "Int64"
		      dim v() as Int64 = returnValue
		      for each element as Int64 in v
		        ret.Append(element)
		      next
		      
		    case "Int32"
		      dim v() as Int32 = returnValue
		      for each element as Int32 in v
		        ret.Append(element)
		      next
		      
		    case "Int8"
		      dim v() as Int8 = returnValue
		      for each element as Int8 in v
		        ret.Append(element)
		      next
		      
		    case "UInteger"
		      dim v() as UInteger = returnValue
		      for each element as UInteger in v
		        ret.Append(element)
		      next
		      
		    case "UInt64"
		      dim v() as UInt64 = returnValue
		      for each element as UInt64 in v
		        ret.Append(element)
		      next
		      
		    case "UInt32"
		      dim v() as UInt32 = returnValue
		      for each element as UInt32 in v
		        ret.Append(element)
		      next
		      
		    case "UInt8"
		      dim v() as UInt8 = returnValue
		      for each element as UInt8 in v
		        ret.Append(element)
		      next
		      
		    case "Double"
		      dim v() as double = returnValue
		      for each element as double in v
		        ret.Append(element)
		      next
		      
		    case "Boolean"
		      dim v() as boolean = returnValue
		      for each element as boolean in v
		        ret.Append(element)
		      next
		      
		    case "Single"
		      dim v() as single = returnValue
		      for each element as single in v
		        ret.Append(element)
		      next
		      
		    case "Color"
		      dim v() as Color = returnValue
		      for each element as Color in v
		        'GenerateJSON() throws InvalidArgumentException when trying to serialize Colors, so we convert them to strings
		        ret.Append(str(element))
		      next
		      
		    case "Currency"
		      dim v() as Currency = returnValue
		      for each element as Currency in v
		        'from the Xojo docs: 'Currency is not a valid type that can be converted to JSON.', so we convert it to strings
		        ret.Append(element.ToText())
		      next
		      
		    case else
		      Raise New XosonException(ParseError.UnsupportedType, "Type "+ returnElementType.FullName + " is not supported")
		      
		    end select
		    
		  else
		    Raise New XosonException(ParseError.UnsupportedType, "The type " + returnElementType.FullName + " is not (de-)serializable.")
		    
		  end if
		  
		  Return ret
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub arrayParser(json() As Auto, ByRef returnValue As Auto, returnElementType As Xojo.Introspection.TypeInfo)
		  'parses a json array into a Xojo array of any type
		  '@param returnValue the array into which to parse. Must be of the type to parse
		  '@param returnElementType the type of array elements. Only necessary when array elements are objects
		  '@throws XosonException containing the error occured while parsing
		  
		  Dim returnType As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(returnValue)
		  
		  If Not returnType.IsArray Then Raise New XosonException(ParseError.TypeNotMatching, "Expected array")
		  If returnType.ArrayRank > 1 then Raise New XosonException(ParseError.MultiDimArray, "Multi-dimensional arrays are not supported") 'feel free to implement
		  
		  Dim childCount As Integer = json.Ubound()
		  
		  Dim typeName As String = returnType.ArrayElementType().FullName
		  if returnElementType.IsInterface or returnElementType.IsEnum or returnElementType.IsPointer then
		    Raise New XosonException(ParseError.UnsupportedType, "The type " + returnElementType.FullName + " is not (de-)serializable.")
		    
		  elseif returnElementType.IsClass or typeName = "Object" then 'Odd: class array's element types have IsClass set to false, but "Object" as name...
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
		          fromJSONImpl(o, dict)
		        end if
		        v.Append(o)
		      next
		      
		    end if
		    
		  elseif returnElementType.IsPrimitive then
		    select case typeName
		    case "String"
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
		      
		    case "Text"
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
		      
		    case "Integer"
		      dim v() as integer = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), Integer))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "Int64"
		      dim v() as Int64 = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), Int64))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "Int32"
		      dim v() as Int32 = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), Int32))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "Int8"
		      dim v() as Int8 = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), Int8))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "UInteger"
		      dim v() as UInteger = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), UInteger))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "UInt64"
		      dim v() as UInt64 = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), UInt64))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "Int32"
		      dim v() as UInt32 = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), UInt32))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "Int8"
		      dim v() as UInt8 = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), UInt8))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "Double"
		      dim v() as double = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), Double))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "Boolean"
		      dim v() as boolean = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), Boolean))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "Single"
		      dim v() as single = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), Single))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "Color"
		      dim v() as Color = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          Dim intermediate As Int32 = Val(CType(json(i), String))
		          v.Append(Color(intermediate))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case "Currency"
		      dim v() as Currency = returnValue
		      ReDim v(-1)
		      try
		        for i As Integer = 0 to childCount
		          v.Append(CType(json(i), Currency))
		        next
		      catch exc As TypeMismatchException
		        Raise New XosonException(ParseError.TypeNotMatching, exc.message)
		      end try
		      
		    case else
		      Raise New XosonException(ParseError.UnsupportedType, "Type "+ returnType.ArrayElementType.FullName + " is not supported")
		    end select
		    
		  else
		    Raise New XosonException(ParseError.UnsupportedType, "The type " + returnElementType.FullName + " is not (de-)serializable.")
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function convertDate(d As Date) As String
		  'simple Dates are always considered to be in the current timezone (TODO make configurable)
		  Dim tz As Xojo.Core.TimeZone = Xojo.Core.TimeZone.Current()
		  Dim utcDate As New Date(d)
		  utcDate.TotalSeconds = utcDate.TotalSeconds - tz.SecondsFromGMT
		  
		  Dim mb As New MemoryBlock(24)
		  mb.StringValue(0,4) = Format(utcDate.Year, "0000")
		  mb.Byte(4) = &h2D
		  mb.StringValue(5,2) = Format(utcDate.Month, "00")
		  mb.Byte(7) = &h2D
		  mb.StringValue(8,2) = Format(utcDate.Day, "00")
		  mb.Byte(10) = &h54
		  mb.StringValue(11,2) = Format(utcDate.Hour, "00")
		  mb.Byte(13) = &h3A
		  mb.StringValue(14,2) = Format(utcDate.Minute, "00")
		  mb.Byte(16) = &h3A
		  mb.StringValue(17,2) = Format(utcDate.Second, "00")
		  mb.Byte(19) = &h2E
		  mb.StringValue(20,3) = "000" 'milliseconds are not available in Date
		  mb.Byte(23) = &h5A
		  return DefineEncoding(mb.StringValue(0, 24), Encodings.UTF8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function convertXojoDate(d As Xojo.Core.Date) As String
		  Dim utcDate As New Xojo.Core.Date(d.SecondsFrom1970, New Xojo.Core.TimeZone(0))
		  
		  Dim mb As New MemoryBlock(24)
		  mb.StringValue(0,4) = Format(utcDate.Year, "0000")
		  mb.Byte(4) = &h2D
		  mb.StringValue(5,2) = Format(utcDate.Month, "00")
		  mb.Byte(7) = &h2D
		  mb.StringValue(8,2) = Format(utcDate.Day, "00")
		  mb.Byte(10) = &h54
		  mb.StringValue(11,2) = Format(utcDate.Hour, "00")
		  mb.Byte(13) = &h3A
		  mb.StringValue(14,2) = Format(utcDate.Minute, "00")
		  mb.Byte(16) = &h3A
		  mb.StringValue(17,2) = Format(utcDate.Second, "00")
		  mb.Byte(19) = &h2E
		  mb.StringValue(20,3) = Format(utcDate.Nanosecond / 1000, "000")
		  mb.Byte(23) = &h5A
		  return DefineEncoding(mb.StringValue(0, 24), Encodings.UTF8)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fromJSON(obj As Auto, json As Text)
		  '@see fromJSON(extends obj As Object, json As Xojo.Core.Dictionary)
		  '@throws additionally the InvalidJSONException, if json is not JSON-formatted
		  
		  fromJSONImpl(obj, Xojo.Data.ParseJSON(json))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub fromJSONImpl(obj As Auto, json As Auto)
		  'sets properties of obj to corresponding values from json object
		  '@param obj the object to parse values in
		  '@param json the deserialized JSON to parse (return value of Xojo.Data.ParseJSON)
		  '@throws XosonException if parsing failed
		  
		  if json = Nil then Raise New XosonException(Xoson.ParseError.InternalError, "json must not be nil in fromJSONImpl()")
		  
		  Dim objTypeInfo As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(obj)
		  Dim jsonTypeInfo As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(json)
		  
		  if objTypeInfo.IsArray and not jsonTypeInfo.IsArray then
		    Raise New XosonException(ParseError.TypeNotMatching, "Object type " + objTypeInfo.Name + " is array but JSON type " + jsonTypeInfo.Name + " is non-array.")
		    'TODO more tests about the two types
		  end if
		  
		  if objTypeInfo.IsArray then
		    Dim elementType As Xojo.Introspection.TypeInfo = objTypeInfo.ArrayElementType()
		    arrayParser(json, obj, elementType)
		    
		  elseif objTypeInfo.IsEnum or objTypeInfo.IsPrimitive then
		    Raise New XosonException(ParseError.UnsupportedType, "The type " + objTypeInfo.FullName + " is not (de-)serializable.")
		    
		  else
		    'prepare Dictionary with (name : PropertyInfo) for fast access
		    Dim props() As Xojo.Introspection.PropertyInfo = objTypeInfo.Properties
		    Dim propsDict As New Xojo.Core.Dictionary
		    for each prop As Xojo.Introspection.PropertyInfo in props
		      if prop.canWrite and prop.isPublic and not prop.isShared then propsDict.Value(prop.Name) = prop
		    next
		    
		    for each entry as Xojo.Core.DictionaryEntry in ctype(json, Xojo.Core.Dictionary)
		      Dim name As Text = entry.Key
		      Dim propertyInfo As Xojo.Introspection.PropertyInfo = propsDict.Lookup(name, Nil)
		      if propertyInfo = Nil then Continue 'silently ignore properties not present in the target - TODO make strictness configurable
		      Dim propertyType As Xojo.Introspection.TypeInfo = propertyInfo.PropertyType
		      Dim childValue As Auto = entry.Value
		      Dim childType As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(childValue)
		      
		      if implicitlyConvertible(childType, propertyType) then
		        propertyInfo.Value(obj) = childValue
		        
		      elseif childType.IsArray then
		        Dim elementType As Xojo.Introspection.TypeInfo = propertyType.ArrayElementType()
		        Dim arrayProperty As Auto = propertyInfo.Value(obj)
		        arrayParser(childValue, arrayProperty, elementType)
		        
		      elseif sameMetaType(childType, propertyType) then
		        if childType = GetTypeInfo(Xojo.Core.Dictionary) then
		          Dim childItem As Xojo.Core.Dictionary = Xojo.Core.Dictionary(childValue)
		          
		          if propertyInfo.Value(obj) = nil then
		            Dim cons As Xojo.Introspection.ConstructorInfo = getSimpleConstructor(propertyType)
		            if cons = Nil then Raise New XosonException(ParseError.NoSimpleConstructor, "No constructor with 0 parameters for class " + propertyType.Name)
		            
		            Dim member As object = cons.Invoke()
		            fromJSONImpl(member, childItem)
		            propertyInfo.Value(obj) = member
		          else
		            fromJSONImpl(propertyInfo.Value(obj), childItem)
		          end if
		          
		        end if
		        
		      elseif (propertyType = GetTypeInfo(Date) or propertyType = GetTypeInfo(Xojo.Core.Date)) _
		        and (childType = GetTypeInfo(Text) or childType = GetTypeInfo(String)) then
		        
		        if propertyType = GetTypeInfo(Xojo.Core.Date) then
		          propertyInfo.Value(obj) = parseXojoDate(childValue)
		        else
		          propertyInfo.Value(obj) = parseDate(childValue)
		        end if
		        
		      end if
		      
		    next
		  end if
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
		Private Function implicitlyConvertible(typeA As Xojo.Introspection.TypeInfo, typeB As Xojo.Introspection.TypeInfo) As Boolean
		  if typeA = nil or typeB = nil then Raise New XosonException(Xoson.ParseError.InternalError, "typeA and typeB must not be nil in implicitlyConvertible()")
		  
		  'convert...
		  '* Text and String
		  '* all integers and floating points
		  '... to each other
		  'TODO make strictness configurable: do not convert bigger types to smaller (e.g., do not convert Int64 to Int32)
		  return (typeA = typeB) or (typeA.IsPrimitive and typeB.IsPrimitive and not isUnconvertable(typeA) and not isUnconvertable(typeB)) or _
		  (typeA = GetTypeInfo(Text) and typeB = GetTypeInfo(String) or typeA = GetTypeInfo(String) and typeB = GetTypeInfo(Text))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function isUnconvertable(aType As Xojo.Introspection.TypeInfo) As Boolean
		  return aType <> nil and ( _
		  aType = GetTypeInfo(Boolean) or _
		  aType = GetTypeInfo(Color) or _
		  aType = GetTypeInfo(String) or _
		  aType = GetTypeInfo(Text) or _
		  aType = GetTypeInfo(Currency))
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
		  
		  return New Xojo.Core.Date(d.year, d.month, d.day, d.hour, d.minute, d.second, d.millisecond * 1000, new Xojo.Core.TimeZone(0))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function sameMetaType(typeA As Xojo.Introspection.TypeInfo, typeB As Xojo.Introspection.TypeInfo) As Boolean
		  if typeA = nil or typeB = nil then Raise New XosonException(Xoson.ParseError.InternalError, "typeA and typeB must not be nil in sameMetaType()")
		  
		  return (typeA.IsPrimitive and typeB.IsPrimitive) or _
		  (typeA.IsClass and typeB.IsClass) or _
		  (typeA.IsArray and typeB.IsArray and typeA.ArrayRank() = typeB.ArrayRank() and sameMetaType(typeA.ArrayElementType, typeB.ArrayElementType)) or _
		  (typeA.IsInterface and typeB.IsInterface) or _
		  (typeA.IsPointer and typeB.IsPointer)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function toJSON(obj As Auto) As Text
		  Dim dict As Auto = toJSONImpl(obj)
		  return Xojo.Data.GenerateJSON(dict)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function toJSONImpl(obj As Auto) As Auto
		  'converts an object or an array of objects into a dictionary or array of dictionarys to be used by Xojo.Data.GenerateJSON()
		  '@param obj the object(s) to serialize. All publicly readable, non-shared properties are considered.
		  '@return the JSON
		  
		  Dim tpInfo As Xojo.Introspection.TypeInfo = Xojo.Introspection.GetType(obj)
		  
		  if tpInfo.IsArray then
		    Dim elementType As Xojo.Introspection.TypeInfo = tpInfo.ArrayElementType()
		    return arrayConverter(obj, elementType)
		    
		  elseif tpInfo.IsEnum or tpInfo.IsPrimitive then
		    Raise New XosonException(ParseError.UnsupportedType, "The type " + tpInfo.FullName + " is not (de-)serializable.")
		    
		  else
		    Dim ret As New Xojo.Core.Dictionary()
		    While tpInfo <> Nil
		      
		      Dim props() As Xojo.Introspection.PropertyInfo = tpInfo.Properties
		      For each prop As Xojo.Introspection.PropertyInfo In props
		        If not prop.IsPublic or not prop.CanRead Then Continue
		        
		        if prop.PropertyType.isClass then
		          if prop.Value(obj) = nil then
		            ret.Value(prop.Name) = nil
		          elseif prop.PropertyType = GetTypeInfo(Date) then
		            ret.Value(prop.Name) = convertDate(prop.Value(obj))
		          elseif prop.PropertyType = GetTypeInfo(Xojo.Core.Date) then
		            ret.Value(prop.Name) = convertXojoDate(prop.Value(obj))
		          else
		            ret.Value(prop.Name) = toJSONImpl(prop.Value(obj))
		          end if
		        elseif prop.PropertyType = GetTypeInfo(String) then
		          ret.Value(prop.Name) = ConvertEncoding(ctype(prop.Value(obj), String), Encodings.UTF8)
		          
		        elseif prop.PropertyType = GetTypeInfo(Color) then
		          ret.Value(prop.Name) = str(ctype(prop.Value(obj), Color))
		          
		        elseif prop.PropertyType.isArray then
		          ret.Value(prop.Name) = arrayConverter(prop.Value(obj), prop.PropertyType.ArrayElementType)
		          
		        else
		          ret.Value(prop.Name) = prop.Value(obj)
		          
		        end if
		        
		      Next
		      
		      tpInfo = tpInfo.BaseType
		    Wend
		    
		    Return ret
		    
		  end if
		End Function
	#tag EndMethod


	#tag Enum, Name = ParseError, Type = Integer, Flags = &h1
		NoError
		  TypeNotMatching
		  NoSimpleConstructor
		  UnsupportedType
		  MultiDimArray
		InternalError
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
