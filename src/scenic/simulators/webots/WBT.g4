grammar WBT;

world : (node | defn)* ;

defn : 'DEF' Identifier node;

node : Identifier ' {' Newline nodeBody '}' Newline? ;

nodeBody : (attribute Newline)* ;

attribute
	: 'hidden' Identifier value
	| Identifier value ;

value : vector | string | array | node | boolean ;

vector : Number+ ;

string : String ;

/* The VRML grammar is highly ambiguous for multi-valued fields:
   we have no way of knowing whether whitespace (including newlines)
   separates two different values or components of a single value.
   The intended solution is to use type information about each field;
   instead, we use the following simple heuristic: vectors may be
   separated by commas, everything else only by newlines. This works
   for the two .wbt files I've looked at... */
array
	: '[' (Newline value)* Newline? ']'
	| '[' vectorWithNewlines (',' vectorWithNewlines)+ ','? ']' ;

vectorWithNewlines: (Newline? Number Newline?)+ ;

boolean : 'TRUE' | 'FALSE' ;

Comment : '#' .*? Newline -> skip ;

Whitespace : [ \t]+ -> skip ;

Identifier : Letter (Letter | Digit)* ;

fragment
Letter : [a-zA-Z_] ;

Number : '-'? Digit+ ('.' Digit+)? ('e' '-'? Digit+)? ;

fragment
Digit : [0-9] ;

String : '"' (~["\\] | '\\"' | '\\\\')* '"' ;

Newline : '\r'? '\n' ;
