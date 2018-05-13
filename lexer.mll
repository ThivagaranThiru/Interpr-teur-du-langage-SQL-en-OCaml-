{
open Parser
exception Eof
}

(* Déclaration du dictionnaire (regexp -> terminal/token) *)

rule anlex = parse
| [' ' '\t' '\n' '\r']     { anlex lexbuf}
| '+'                      { PLUS }
| '*'                      { ASTERIX }
| '/'                      { DIV }
| '-'                      { MINUS }
| '('                      { LPAR }
| ')'                      { RPAR }
| "\""                     { QQUOTE }
| ";;"                     { TERM }
| eof                      { raise Eof}
| "||"                     { PPIPE }
| '.'                      { DOT }
| '='                      { EQ }
| ','                      { COMA }
| "'"                      { string1 "" lexbuf}
| '<'                      { LT }
| '>'                      { GT }
| "<>"                     { NEQ }
| "<="                     { LE }
| ">="                     { GE }
| "ALL"                    { ALL }
| "AND"                    { AND }
| "AS"                     { AS }
| "BETWEEN"                { BETWEEN }
| "BY"                     { BY }
| "CROSS"                  { CROSS }
| "DISTINCT"               { DISTINCT }
| "FALSE"                  { FALSE }
| "FOR"                    { FOR }
| "FROM"                   { FROM }
| "FULL"                   { FULL }
| "GROUP"                  { GROUP }
| "HAVING"                 { HAVING }
| "INNER"                  { INNER }
| "IS"                     { IS }
| "JOIN"                   { JOIN }
| "LEFT"                   { LEFT }
| "LOWER"                  { LOWER }
| "NOT"                    { NOT }
| "NULL"                   { NULL }
| "ON"                     { ON }
| "OR"                     { OR }
| "OUTER"                  { OUTER }
| "RIGHT"                  { RIGHT }
| "SELECT"                 { SELECT }
| "SUBSTRING"              { SUBSTRING }
| "TRUE"                   { TRUE }
| "UNKNOWN"                { UNKNOWN }
| "UPPER"                  { UPPER }
| "WHERE"                  { WHERE }  
| ['0' - '9']+ as lxm      { INT (int_of_string lxm) }
| ((['0' - '9']+ '.' ['0' - '9']* (('e' | 'E') ('-' | '+') ['0' - '9']+)?) | ('.' ['0' - '9']+ (('e' | 'E') ('+' | '-') ['0' - '9']+)?))  as flo { FLOAT (float_of_string flo) }
| ['a'-'z' 'A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9']* as id { ID id }
| "--"                     { comment 0 lexbuf }
and comment n = parse 
	 |"\n"                 { if n = 0 then anlex lexbuf else comment (n-1) lexbuf } 
	 |"--"                 { comment (n+1) lexbuf }
	 | _                   { comment n lexbuf}               
and string1 b = parse 
     |"'"                  { STRING(b) }
     | _ as lxm            { string (b ^ (String.make 1) lxm) lexbuf }
 | _  as lxm                 { (* Pour tout autre caractère : message sur la sortie erreur + oubli *)
                               Printf.eprintf "Unknown character '%c': ignored\n" lxm; flush stderr;
                               anlex lexbuf
                              }
