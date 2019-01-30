%lex

%options case-insensitive

%%

(['](\\.|[^']|\\\')*?['])+                  	return 'STRING'

"--"(.*?)($|\r\n|\r|\n)							/* skip -- comments */

\s+   											/* skip whitespace */

'CREATE'                                        return 'CREATE'        
'TABLE'                                         return 'TABLE'       

[-]?(\d*[.])?\d+[eE]\d+							return 'NUMBER'
[-]?(\d*[.])?\d+								return 'NUMBER'

'+'												return 'PLUS'
'-' 											return 'MINUS'
'*'												return 'STAR'
'/'												return 'SLASH'
'%'												return 'REM'
'>>'											return 'RSHIFT'
'<<'											return 'LSHIFT'
'<>'											return 'NE'
'!='											return 'NE'
'>='											return 'GE'
'>'												return 'GT'
'<='											return 'LE'
'<'												return 'LT'
'='												return 'EQ'
'&'												return 'BITAND'
'|'												return 'BITOR'

'('												return 'LPAR'
')'												return 'RPAR'

'.'												return 'DOT'
','												return 'COMMA'
':'												return 'COLON'
';'												return 'SEMICOLON'
'$'												return 'DOLLAR'
'?'												return 'QUESTION'
'^'												return 'CARET'

[a-zA-Z_][a-zA-Z_0-9]*                       	return 'LITERAL'

<<EOF>>               							return 'EOF'
.												return 'INVALID'

/lex

/* %left unary_operator binary_operator  */

%left OR
%left BETWEEN
%left AND
%right NOT
%left IS MATCH LIKE IN ISNULL NOTNULL NE EQ
%left ESCAPE
%left GT LE LT GE
%left BITAND BITOR LSHIFT RSHIFT
$left PLUS MINUS
%left STAR SLASH REM
%left CONCAT
%left COLLATE
%right BITNOT


%start main

%%

main
    : sql_stmt_list EOF
        {
            $$ = $1;
            return $$;
        }
    ;

sql_stmt_list
    : sql_stmt_list SEMICOLON sql_stmt
        { $$ = $1; if($3) $$.push($3); }
    | sql_stmt
        { $$ = [$1]; }
    ;

sql_stmt
    :
        { $$ = undefined; }
    ;

sql_stmt
    : create_table_stmt
    ;

create_table_stmt
    : CREATE TABLE database_table_name LPAR column_defs RPAR
        {
            $$ = {
                statement: 'CREATE TABLE',
                column_defs: $5
            };
            yy.extend($$, $3);
        }
    ;

database_table_name
    : name DOT name
        { $$ = {database:$1, table:$3}; }
    | name
        { $$ = {table:$1}; }
    ;

name
    : LITERAL
        { $$ = $1; }
    ;

column_defs
    : column_defs COMMA column_def
        { $$ = $1; $$.push($3); }
    | column_def
        { $$ = [$1]; }
    ;

column_def
    : name type_name
        { $$ = {column:$1}; yy.extend($$,$2); }
    ;

type_name
	: name
		{ $$ = {type: $1.toUpperCase()}; }
	;