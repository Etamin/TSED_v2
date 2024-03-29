/*
BSD License

Copyright (c) 2020, Tom Everett
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the name of Tom Everett nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// https://www.loc.gov/standards/sru/cql/spec.html

// $antlr-format alignTrailingComments true, columnLimit 150, minEmptyLines 1, maxEmptyLinesToKeep 1, reflowComments false, useTab false
// $antlr-format allowShortRulesOnASingleLine false, allowShortBlocksOnASingleLine true, alignSemicolons hanging, alignColons hanging

grammar cql;

options {
    caseInsensitive = true;
}

cql
    : sortedQuery EOF
    ;

sortedQuery
    : prefixAssignment sortedQuery
    | scopedClause (SORTBY sortSpec)?
    ;

sortSpec
    : sortSpec singleSpec
    | singleSpec
    ;

singleSpec
    : index modifierList?
    ;

cqlQuery
    : prefixAssignment cqlQuery
    | scopedClause
    ;

prefixAssignment
    : '>' prefix_ '=' uri
    | '>' uri
    ;

scopedClause
    : scopedClause booleanGroup searchClause
    | searchClause
    ;

booleanGroup
    : boolean_ modifierList?
    ;

boolean_
    : AND
    | OR
    | NOT
    | PROX
    ;

searchClause
    : '(' cqlQuery ')'
    | index relation searchTerm
    | searchTerm
    ;

relation
    : comparitor modifierList?
    ;

comparitor
    : comparitorSymbol
    | namedComparitor
    ;

comparitorSymbol
    : '='
    | '>'
    | '<'
    | '>='
    | '<='
    | '<>'
    | '=='
    ;

namedComparitor
    : identifier
    ;

modifierList
    : modifierList modifier
    | modifier
    ;

modifier
    : '/' modifierName (comparitorSymbol modifierValue)?
    ;

prefix_
    : term
    ;

uri
    : term
    ;

modifierName
    : term
    ;

modifierValue
    : term
    ;

searchTerm
    : term
    ;

index
    : term
    ;

term
    : identifier
    | AND
    | OR
    | NOT
    | PROX
    | SORTBY
    ;

identifier
    : CHARSTRING1
    | CHARSTRING2
    ;

AND
    : 'AND'
    ;

OR
    : 'OR'
    ;

NOT
    : 'NOT'
    ;

PROX
    : 'PROX'
    ;

SORTBY
    : 'SORTBY'
    ;

CHARSTRING1
    : [A-Z.]+
    ;

CHARSTRING2
    : '"' .*? '"'
    ;

WS
    : [ \r\n\t]+ -> skip
    ;