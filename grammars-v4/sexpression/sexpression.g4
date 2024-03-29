/*
The MIT License

Copyright (c) 2008 Robert Stehwien

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

/*
Port to Antlr4 by Tom Everett
*/

// $antlr-format alignTrailingComments true, columnLimit 150, minEmptyLines 1, maxEmptyLinesToKeep 1, reflowComments false, useTab false
// $antlr-format allowShortRulesOnASingleLine false, allowShortBlocksOnASingleLine true, alignSemicolons hanging, alignColons hanging

grammar sexpression;

sexpr
    : item* EOF
    ;

item
    : atom
    | list_
    | LPAREN item DOT item RPAREN
    ;

list_
    : LPAREN item* RPAREN
    ;

atom
    : STRING
    | SYMBOL
    | NUMBER
    | DOT
    ;

STRING
    : '"' ('\\' . | ~ ('\\' | '"'))* '"'
    ;

WHITESPACE
    : (' ' | '\n' | '\t' | '\r')+ -> skip
    ;

NUMBER
    : ('+' | '-')? (DIGIT)+ ('.' (DIGIT)+)?
    ;

SYMBOL
    : SYMBOL_START (SYMBOL_START | DIGIT)*
    ;

LPAREN
    : '('
    ;

RPAREN
    : ')'
    ;

DOT
    : '.'
    ;

fragment SYMBOL_START
    : ('a' .. 'z')
    | ('A' .. 'Z')
    | '+'
    | '-'
    | '*'
    | '/'
    | '.'
    ;

fragment DIGIT
    : ('0' .. '9')
    ;