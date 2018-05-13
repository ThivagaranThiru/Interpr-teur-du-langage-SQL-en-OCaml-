%{

open Ast

%}

/* Déclaration des terminaux */
%token <int> INT 
%token <string> STRING 
%token <string> ID
%token <float> FLOAT
%token PLUS MINUS ASTERIX SLASH 
%token LPAR RPAR
%token QQOTE PPIPE DOT EQ COMA QUOTE
%token LT GT NEQ LE GE
%token ALL AND AS BETWEEN BY
%token CROSS DISTINCT FALSE
%token FOR FROM FULL 
%token GROUP HAVING 
%token INNER IS JOIN
%token LEFT LOWER 
%token NOT NULL ON OR 
%token OUTER RIGHT SELECT
%token SUBSTRING TRUE UNKNOWN
%token UPPER WHERE
%token TERM

/* Précédences (priorité + associativité) des terminaux */
%left FROM 
%left WHERE
%left SELECT
%left PPIPE COMA
%left LT GT LE GE NEQ EQ BETWEEN
%left PLUS MINUS
%left ASTERIX SLASH 
%nonassoc UMINUS
%left INNER JOIN CROSS OUTLER LEFT RIGHT FULL
%left OR
%left AND
%left NOT
%left IS 

/* Déclaration du non-terminal axiome (ici, ansyn) et du type de son attribut */
%type <Ast.expr> ansyn
%start ansyn

%%

/* Déclaration de la grammaire avec les actions sémantiques */

ansyn:
  | TERM ansyn              { $2 }
  | expr TERM               { $1 }  
;

simple_query:
|SELECT projection FROM source where           { squery $2 $4 $5 }
|SELECT ALL projection FROM source where       { squery $3 $5 $6 }
|SELECT DISTINCT projection FROM source where  { squery $3 $5 $6 }


where: 
|             			 { trUe }
|WHERE condition         { $2 }

projection: 
|ASTERIX                 { asterix }
|projection_bis          { pro $1 }

projection_bis:
|column 				         { col $1 }
|column COMA projection_bis     { col2 $1 $3 }


column: 
|expr                    { ex $1 }
|expr AS ID              { exid $1 $3 }

source: 
|ID 					  { id $1 }
|LPAR simple_query RPAR   { squery $2 }
|source COMA source      { comma $1 $3 }
|source CROSS JOIN  source  { crossjoIn $1 $4 }
|source joinop source ON condition { joinOp $1 $2 $3 $5 }


joinop:
|JOIN              { join }
|INNER JOIN        { innerjoin }
|LEFT JOIN         { leftjoin }
|LEFT OUTER JOIN   { leftouterjoin }
|RIGHT JOIN        { rightjoin }
|RIGHT OUTER JOIN  { rightouterjoin }
|FULL JOIN         { fulljoin }
|FULL OUTER JOIN   { fullouterjoin }

condition:
|predicate         { pred $1 }
|NOT condition      { no $2 }
|condition AND condition { anD $1 $3 }
|condition OR condition { oR $1 $3 }
|condition IS boolean   { is $1 $3 }
|condition IS NOT boolean { isnot $1 $4 }

boolean:
|TRUE              { trUe }
|FALSE             { falSe }
|UNKNOWN           { unknoWn }

predicate:
|LPAR condition RPAR { par $2 }
|expr sep expr       { seP $1 $3 $2 }
|expr BETWEEN expr AND expr { betand $1 $3 $5 }
|expr NOT BETWEEN expr AND expr { notbetand $1 $4 $6 }
|expr IS NULL                   { isnull $1 }
|expr IS NOT NULL               { isnotnull $1 }
                           
sep:
|EQ    { eq }
|NEQ   { neq }
|LT    { lt }
|GT    { gt }
|LE    { le }
|GE    { ge }

expr :
|attribute      { att $1 }
|LPAR expr RPAR { parexp $2 }
|INT            { inT $1 }
|FLOAT          { floaT $1 }
|STRING         { strinG $1 }
|expr operation expr { ope $1 $3 $2 }
|MINUS expr %prec UMINUS { umi $2 }
|expr PPIPE expr         { ppie $1 $3}
|LOWER LPAR expr RPAR    { lower $3 }
|UPPER LPAR expr RPAR    { upper $3 }
|SUBSTRING LPAR expr FROM expr FOR expr RPAR { substring $3 $5 $7}


attribute:
|ID DOT ID { dot $1 $3 }

operation:
|PLUS      { plus }
|MINUS     { minus }
|ASTERIX   { astrix }
|SLASH     { slash }
