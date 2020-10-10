# Xoson - Xojo JSON Object Serialization

__Xoson__ provides utilities to convert [Xojo](https://www.xojo.com/) objects to and from [JSON](https://json.org/). The project contains a simple example on how to use the API.

## Requirements

The project makes use of the new `Xojo.Data.*` functions, meaning that **Xojo 2015 and above** are required (not all versions are tested).

## Installation

Copy the __Xoson__ module into your project. The only exported elements are the `XosonException` class and the `[to|from]JSON()` functions.

## Usage

Use the exported functions to convert objects and their properties or arrays to and from JSON.

For instance, the example project in this repository contains the `Sample` class:
```
Protected Class Sample
    decimalNumber As Double
    message As String
    number As Integer
    test As Boolean
    tm() As Xojo.Core.Date
End Class
```

An example object might be created as follows:
```
Dim serializable As New Sample
serializable.decimalNumber = 10.0
serializable.number = 1
serializable.Message = "These violent delights have violent ends"
serializable.tm.Append(Xojo.Core.Date.Now)

Dim serialization As Text = serializable.toJSONText()

'prints {"decimalNumber":10.0,"message":"These violent delights have violent ends","number":1,"test":false,"tm":["2019-03-04T10:04:13.000Z"]}
Print(serialization)
```

## Notes

* Only **public** properties are considered (feel free to change the code).
* For **de**-serialization (`fromJSON()`), properties must be primitive, dates (`Date` and `Xojo.Core.Date`) or of a class with a public trivial constructor (no parameters). Arrays of those types are also supported.
* Dates are serialized and read as **ISO8601** in **UTC** (to get millisecond-level precision, use `Xojo.Core.Date` instead of `Date`).
* Multi-dimensional arrays are not supported. Feel free to contribute.

This project is licensed under the terms of the MIT license.
