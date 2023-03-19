#tag Module
Protected Module O
	#tag Note, Name = README
		This module contains transparent types for optional properties.
		
		Motivation: when you serialize a class, all properties are always rendered to JSON.
		But especially in the context of REST APIs, there are many occurrences of 'optional' properties, e.g. 'description' fields.
		
		With the optional variants of the primitive types, it is possible to not render a property to JSON, when it is not set.
		
		ATTENTION: Arrays of optional types are not supported!
		
	#tag EndNote


End Module
#tag EndModule
