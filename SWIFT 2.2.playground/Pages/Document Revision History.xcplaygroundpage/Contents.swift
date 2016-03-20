/*:
[Previous](@previous)
****
# Document Revision History

This table describes the changes to The Swift Programming Language.

****
2015-10-20
****
* Updated for Swift 2.1.
	
* Updated the String Interpolation and String Literals sections now that string interpolations can contain string literals.

* Added the Nonescaping Closures section with information about the @noescape attribute.

* Updated the Declaration Attributes and Build Configuration Statement sections with information about tvOS.

* Added information about the behavior of in-out parameters to the In-Out Parameters section.

* Added information to the Capture Lists section about how values specified in closure capture lists are captured.

* Updated the Accessing Properties Through Optional Chaining section to clarify how assignment through optional chaining behaves.

* Improved the discussion of autoclosures in the Autoclosures section.

* Added an example that uses the ?? operator to the A Swift Tour chapter.

****
2015-09-16
****

* Updated for Swift 2.0.
	
* Added information about error handling to the Error Handling chapter, the Do Statement section, the Throw Statement section, the Defer Statement section, and the Try Operator section.

* Updated the Representing and Throwing Errors section, now that all types can conform to the ErrorType protocol.

* Added information about the new try? keyword to the Converting Errors to Optional Values section.

* Added information about recursive enumerations to the Recursive Enumerations section of the Enumerations chapter and the Enumerations with Cases of Any Type section of the Declarations chapter.

* Added information about API availability checking to the Checking API Availability section of the Control Flow chapter and the Availability Condition section of the Statements chapter.

* Added information about the new guard statement to the Early Exit section of the Control Flow chapter and the Guard Statement section of the Statements chapter.

* Added information about protocol extensions to the Protocol Extensions section of the Protocols chapter.

* Added information about access control for unit testing to the Access Levels for Unit Test Targets section of the Access Control chapter.

* Added information about the new optional pattern to the Optional Pattern section of the Patterns chapter.

* Updated the Repeat-While section with information about the repeat-while loop.

* Updated the Strings and Characters chapter, now that String no longer conforms to the CollectionType protocol from the Swift standard library.

* Added information about the new Swift standard library print(_:separator:terminator) function to the Printing Constants and Variables section.

* Added information about the behavior of enumeration cases with String raw values to the Implicitly Assigned Raw Values section of the Enumerations chapter and the Enumerations with Cases of a Raw-Value Type section of the Declarations chapter.

* Added information about the @autoclosure attribute—including its @autoclosure(escaping) form—to the Autoclosures section.

* Updated the Declaration Attributes section with information about the @available and @warn_unused_result attributes.

* Updated the Type Attributes section with information about the @convention attribute.

* Added an example of using multiple optional bindings with a where clause to the Optional Binding section.

* Added information to the String Literals section about how concatenating string literals using the + operator happens at compile time.

* Added information to the Metatype Type section about comparing metatype values and using them to construct instances with initializer expressions.

* Added a note to the Debugging with Assertions section about when user-defined assertions are disabled.

* Updated the discussion of the @NSManaged attribute in the Declaration Attributes section, now that the attribute can be applied to certain instance methods.

* Updated the Variadic Parameters section, now that variadic parameters can be declared in any position in a function’s parameter list.

* Added information to the Overriding a Failable Initializer section about how a nonfailable initializer can delegate up to a failable initializer by force-unwrapping the result of the superclass’s initializer.

* Added information about using enumeration cases as functions to the Enumerations with Cases of Any Type section.

* Added information about explicitly referencing an initializer to the Initializer Expression section.

* Added information about build configuration and line control statements to the Compiler Control Statements section.

* Added a note to the Metatype Type section about constructing class instances from metatype values.

* Added a note to the Weak References section about weak references being unsuitable for caching.
	
* Updated a note in the Type Properties section to mention that stored type properties are lazily initialized.

* Updated the Capturing Values section to clarify how variables and constants are captured in closures.

* Updated the Declaration Attributes section to describe when you can apply the @objc attribute to classes.

* Added a note to the Handling Errors section about the performance of executing a throw statement. Added similar information about the do statement in the Do Statement section.

* Updated the Type Properties section with information about stored and computed type properties for classes, structures, and enumerations.

* Updated the Break Statement section with information about labeled break statements.
	
* Updated a note in the Property Observers section to clarify the behavior of willSet and didSet observers.

* Added a note to the Access Levels section with information about the scope of private access.

* Added a note to the Weak References section about the differences in weak references between garbage collected systems and ARC.

* Updated the Special Characters in String Literals section with a more precise definition of Unicode scalars.

****
2015-04-08
****

* Updated for Swift 1.2.
	
* Swift now has a native Set collection type. For more information, see Sets.

* @autoclosure is now an attribute of the parameter declaration, not its type. There is also a new @noescape parameter declaration attribute. For more information, see Declaration Attributes.

* Type methods and properties now use the static keyword as a declaration modifier. For more information see Type Variable Properties.

* Swift now includes the as? and as! failable downcast operators. For more information, see Checking for Protocol Conformance.
	
* Added a new guide section about String Indices.

* Removed the overflow division (&/) and overflow remainder (&%) operators from Overflow Operators.

* Updated the rules for constant and constant property declaration and initialization. For more information, see Constant Declaration.

* Updated the definition of Unicode scalars in string literals. See Special Characters in String Literals.

* Updated Range Operators to note that a half-open range with the same start and end index will be empty.

* Updated Closures Are Reference Types to clarify the capturing rules for variables.
	
* Updated Value Overflow to clarify the overflow behavior of signed and unsigned integers

* Updated Protocol Declaration to clarify protocol declaration scope and members.

* Updated Defining a Capture List to clarify the syntax for weak and unowned references in closure capture lists.

* Updated Operators to explicitly mention examples of supported characters for custom operators, such as those in the Mathematical Operators, Miscellaneous Symbols, and Dingbats Unicode blocks.

* Constants can now be declared without being initialized in local function scope. They must have a set value before first use. For more information, see Constant Declaration.

* In an initializer, constant properties can now only assign a value once. For more information, see Assigning Constant Properties During Initialization.

* Multiple optional bindings can now appear in a single if statement as a comma-separated list of assignment expressions. For more information, see Optional Binding.

* An Optional-Chaining Expression must appear within a postfix expression.

* Protocol casts are no longer limited to @objc protocols.

T* ype casts that can fail at runtime now use the as? or as! operator, and type casts that are guaranteed not to fail use the as operator. For more information, see Type-Casting Operators.

****
2014-10-16
****

* Updated for Swift 1.1.
	
* Added a full guide to Failable Initializers.

* Added a description of Failable Initializer Requirements for protocols.
	
* Constants and variables of type Any can now contain function instances. Updated the example for Any to show how to check for and cast to a function type within a switch statement.

* Enumerations with raw values now have a rawValue property rather than a toRaw() method and a failable initializer with a rawValue parameter rather than a fromRaw() method. For more information, see Raw Values and Enumerations with Cases of a Raw-Value Type.

* Added a new reference section about Failable Initializers, which can trigger initialization failure.

* Custom operators can now contain the ? character. Updated the Operators reference to describe the revised rules. Removed a duplicate description of the valid set of operator characters from Custom Operators.

****
2014-08-18
****

* New document that describes Swift 1.0, Apple’s new programming language for building iOS and OS X apps.

* Added a new section about Initializer Requirements in protocols.

* Added a new section about Class-Only Protocols.

* Assertions can now use string interpolation. Removed a note to the contrary.

* Updated the Concatenating Strings and Characters section to reflect the fact that String and Character values can no longer be combined with the addition operator (+) or addition assignment operator (+=). These operators are now used only with String values. Use the String type’s append(_:) method to append a single Character value onto the end of a string.

* Added information about the availability attribute to the Declaration Attributes section.

* Optionals no longer implicitly evaluate to true when they have a value and false when they do not, to avoid confusion when working with optional Bool values. Instead, make an explicit check against nil with the == or != operators to find out if an optional contains a value.

* Swift now has a Nil Coalescing Operator (a ?? b), which unwraps an optional’s value if it exists, or returns a default value if the optional is nil.

* Updated and expanded the Comparing Strings section to reflect and demonstrate that string and character comparison and prefix / suffix comparison are now based on Unicode canonical equivalence of extended grapheme clusters.

* You can now try to set a property’s value, assign to a subscript, or call a mutating method or operator through Optional Chaining. The information about Accessing Properties Through Optional Chaining has been updated accordingly, and the examples of checking for method call success in Calling Methods Through Optional Chaining have been expanded to show how to check for property setting success.

* Added a new section about Accessing Subscripts of Optional Type through optional chaining.

* Updated the Accessing and Modifying an Array section to note that you can no longer append a single item to an array with the += operator. Instead, use the append(_:) method, or append a single-item array with the += operator.

* Added a note that the start value a for the Range Operators a...b and a..<b must not be greater than the end value b.

* Rewrote the Inheritance chapter to remove its introductory coverage of initializer overrides. This chapter now focuses more on the addition of new functionality in a subclass, and the modification of existing functionality with overrides. The chapter’s example of Overriding Property Getters and Setters has been rewritten to show how to override a description property. (The examples of modifying an inherited property’s default value in a subclass initializer have been moved to the Initialization chapter.)

* Updated the Initializer Inheritance and Overriding section to note that overrides of a designated initializer must now be marked with the override modifier.

* Updated the Required Initializers section to note that the required modifier is now written before every subclass implementation of a required initializer, and that the requirements for required initializers can now be satisfied by automatically inherited initializers.

* Infix Operator Functions no longer require the @infix attribute.

* The @prefix and @postfix attributes for Prefix and Postfix Operators have been replaced by prefix and postfix declaration modifiers.

* Added a note about the order in which Prefix and Postfix Operators are applied when both a prefix and a postfix operator are applied to the same operand.

* Operator functions for Compound Assignment Operators no longer use the @assignment attribute when defining the function.

* The order in which modifiers are specified when defining Custom Operators has changed. You now write prefix operator rather than operator prefix, for example.

* Added information about the dynamic declaration modifier in Declaration Modifiers.

* Added information about how type inference works with Literals.

* Added more information about Curried Functions.

* Added a new chapter about Access Control.

* Updated the Strings and Characters chapter to reflect the fact that Swift’s Character type now represents a single Unicode extended grapheme cluster. Includes a new section on Extended Grapheme Clusters and more information about Unicode Scalars and Comparing Strings.

* Updated the String Literals section to note that Unicode scalars inside string literals are now written as \u{n}, where n is a hexadecimal number between 0 and 10FFFF, the range of Unicode’s codespace.

* The NSString length property is now mapped onto Swift’s native String type as utf16Count, not utf16count.

* Swift’s native String type no longer has an uppercaseString or lowercaseString property. The corresponding section in Strings and Characters has been removed, and various code examples have been updated.

* Added a new section about Initializer Parameters Without External Names.

* Added a new section about Required Initializers.

* Added a new section about Optional Tuple Return Types.

* Updated the Type Annotations section to note that multiple related variables can be defined on a single line with one type annotation.

* The @optional, @lazy, @final, and @required attributes are now the optional, lazy, final, and required Declaration Modifiers.

* Updated the entire book to refer to ..< as the Half-Open Range Operator (rather than the “half-closed range operator”).

* Updated the Accessing and Modifying a Dictionary section to note that Dictionary now has a Boolean isEmpty property.

* Clarified the full list of characters that can be used when defining Custom Operators.

* nil and the Booleans true and false are now Literals.

* Swift’s Array type now has full value semantics. Updated the information about Mutability of Collections and Arrays to reflect the new approach. Also clarified the Assignment and Copy Behavior for Strings, Arrays, and Dictionaries.
	
	Array Type Shorthand Syntax is now written as [SomeType] rather than SomeType[].

* Added a new section about Dictionary Type Shorthand Syntax, which is written as [KeyType: ValueType].

* Added a new section about Hash Values for Set Types.
	
* Examples of Closure Expressions now use the global sorted(_:_:) function rather than the global sort(_:_:) function, to reflect the new array value semantics.

* Updated the information about Memberwise Initializers for Structure Types to clarify that the memberwise structure initializer is made available even if a structure’s stored properties do not have default values.

* Updated to ..< rather than .. for the Half-Open Range Operator.

* Added an example of Extending a Generic Type.
****

[Next](@next)
*/
