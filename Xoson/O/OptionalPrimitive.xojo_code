#tag Class
Protected Class OptionalPrimitive
	#tag Note, Name = Info
		Base class for all 'Optional...' classes in this module.
		
		Subclasses must have exactly one property, called the 'value' property (although the name does not matter).
		When serializing (toJSON); if Xoson encounters a property of such a class, it will either output:
		- nothing, if the property is nil, or
		- the value of the primitive.
		
		When deserializing (fromJSON); if Xoson encounters a property of such a class, it will do:
		- nothing, if the name is not found in the JSON,
		- create an object of the Optional... class and set the value of the "value" property.
		
		Note: this class would better be an interface, however the Introspection only supports a function `IsSubclassOf`.
		
	#tag EndNote


End Class
#tag EndClass
