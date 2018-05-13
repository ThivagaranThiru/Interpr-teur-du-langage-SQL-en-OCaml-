open Value
open Env
open Relation

module R = Relation.Make(Value)

module Relation =
struct
   
  (* Création des opérations de manipulation des relations à valeur dans Value *)
  include Relation.Make(Value)

  (* Fonctions d'agrégation (à compléter...) *)
  let sum dist =
    fun a r -> fold dist (fun acc v -> match acc with None -> Some v | Some v' -> Some (Value.add v' v)) None a r

end

(* Syntaxe abstraite *)

type simple_query = 
|Squery of projection * source * condition 

and projection = 
|Asterix
|Pro of projection_bis
and projection_bis =
|Col of column 
|Col2 of column * projection_bis
and column = 
|Ex of expr
|ExID of expr * string

and source = 
|ID of string 
|Query of simple_query
|Coma of source * source 
|CrossJoin of source * source 
|JoinOp of source  * joinop * source * condition
and joinop = 
|Join 
|InnerJoin
|LeftJoin
|LeftOuterJoin
|RightJoin
|RightOuterJoin
|FullJoin
|FullOuterJoin 

and condition = 
|Pred of predicate 
|Not of condition
|And of condition * condition 
|Or of condition * condition 
|Is of condition * boolean
|IsNot of condition * boolean 
and boolean = 
|True
|False
|Unknown 

and predicate = 
|Par of condition
|Sep of expr * expr * sep
|BetAnd of expr * expr * expr 
|NotBetAnd of expr * expr * expr 
|IsNull of expr
|IsNotNull of expr
and sep = 
|Eq
|Neq
|Lt
|Gt
|Le
|Ge

and expr = 
|Att of attribute
|Parexp of expr
|Int of int 
|Float of float
|String of string 
|Ope of expr * expr * operation
|Ast of expr * expr 
|Umi of expr 
|Ppipe of expr * expr 
|Lower of expr 
|Upper of expr 
|Substring of expr * expr * expr 

and attribute = 
|Dot of string * string

and operation = 
|Plus
|Minus
|Slash

(* Constructeurs d'expression *)

let squery p s c = Squery(p,s,c);;

let pro a = Pro(a);;
let col b = Col(b);;
let col2 c c2 = Col2(c,c2);;
let ex d = Ex(d);;
let exid e f = ExID(e,f);;

let id g = ID(g);;
let query h = Query(h);;
let coma s1 s2 = Coma(s1,s2);;
let crossjoIn s3 s4 = CrossJoin(s3,s4);;
let joinOp s5 j s6 c1 = JoinOp(s5,j,s6,c1);;

let join = Join;;
let innerjoin = InnerJoin;;
let leftjoin = LeftJoin;;
let leftouterjoin = LeftOuterJoin;;
let rightjoin = RightJoin;;
let rightouterjoin = RightOuterJoin;;
let fulljoin = FullJoin;;
let fullouterjoin = FullOuterJoin;;

let pred i = Pred(i);;
let not j = Not(j);;
let anD k l = And(k,l);;
let oR m n = Or(m,n);;
let is o p = Is(o,p);;
let isnot q r = IsNot(q,r);;

let trUe = True;;
let falSe = False;;
let unknoWn = Unknown;;

let par s = Par(s);;
let seP t u v = Sep(t,u,v) ;;
let betand w x y = BetAnd(w,x,y);;
let notbetand z a1 b1 = NotBetAnd(z,a1,b1);;
let isnull c1 = IsNull(c1);;
let isnotnull d1 = IsNotNull(d1);;

let eq = Eq;;
let neq = Neq;;
let lt = Lt;;
let gt = Gt;;
let le = Le;;
let ge = Ge;;

let att e1 = Att(e1);;
let parexp f1 = Parexp(f1);;
let inT g1 = Int(g1);;
let floaT h1 = Float(h1);;
let strinG i1 = String(i1);;
let ope j1 k1 l1 = Ope(j1,k1,l1);;
let ast a v = Ast(a,v);;
let umi m1 = Umi(m1);;
let ppipe n1 o1 = Ppipe(n1,o1);;
let lower p1 = Lower(p1);;
let upper r1 = Upper(r1);;
let substring s1 t1 u1 = Substring(s1,t1,u1);;

let dot v1 w1 = Dot(v1,w1);;

let plus = Plus;;
let minus = Minus;;
let slash = Slash;;

(* Affichage de l'arbre de syntaxe *)

let rec string_of_simple_query r = 
	match r with 
	|Squery(a,b,c) -> Printf.sprintf "SELECT %sFROM %s WHERE %s" (string_of_projection a) (string_of_source b) (string_of_condition c)

and string_of_projection a = 
	match a with 
	|Asterix -> "*"
	|Pro(b) -> Printf.sprintf "%s" (string_of_projection_bis b)

and string_of_projection_bis a = 
	match a with
	| Col(b) -> Printf.sprintf "%s" (string_of_column b)
	| Col2(c,d) -> Printf.sprintf "%s %s" (string_of_column c) (string_of_projection_bis d)

and string_of_column a = 
	match a with 
	|Ex(b) -> Printf.sprintf "%s" (string_of_exp b )
	|ExID(c,d) -> Printf.sprintf "%s AS %s" (string_of_exp c ) d

and string_of_source a = 
	match a with 
	|ID s -> s 
	|Query(b) -> Printf.sprintf "%s" (string_of_simple_query b)
	|Coma(c,d) -> Printf.sprintf "%s,%s" (string_of_source c) ( string_of_source d )
	|CrossJoin(e,f) -> Printf.sprintf "%s CROSS JOIN %s" (string_of_source e) (string_of_source f)
	|JoinOp(g,h,i,j) -> Printf.sprintf "%s %s %s ON %s" (string_of_source g) (string_of_joinop h) (string_of_source i) (string_of_condition j)

and string_of_joinop a = 
	match a with 
	|Join -> "Join" 
	|InnerJoin -> "InnerJoin"
	|LeftJoin -> "LeftJoin"
	|LeftOuterJoin -> "LeftOuterJoin"
	|RightJoin -> "RightJoin"
	|RightOuterJoin -> "RightOuterJoin"
	|FullJoin -> "FullJoin"
	|FullOuterJoin -> "FullOuterJoin"

and string_of_condition a = 
	match a with 
	|Pred(b) -> Printf.sprintf "%s" (string_of_predicate b)
	|Not(c) -> Printf.sprintf "%s"   (string_of_condition c)
	|And(d,e) -> Printf.sprintf "%s AND %s"  (string_of_condition d) (string_of_condition e)
	|Or(f,g) -> Printf.sprintf "%s OR %s"  (string_of_condition f) (string_of_condition g)
	|Is(h,i) -> Printf.sprintf "%s IS %s"   (string_of_condition h) (string_of_booleAn i)
	|IsNot(j,k) -> Printf.sprintf "%s IS NOT %s"   (string_of_condition j ) (string_of_booleAn k)

and string_of_booleAn a = 
	match a with 
	|True -> "TRUE"
	|False -> "FALSE"
	|Unknown -> "UNKNOWN"

and string_of_predicate a =
	match a with 
	|Par(b) -> Printf.sprintf "%s" (string_of_condition b)
	|Sep(c,d,e) -> Printf.sprintf "%s %s %s" (string_of_exp c) (string_of_sep e) (string_of_exp d)
	|BetAnd(f,g,h) -> Printf.sprintf "%s BETWEEN %s AND %s" (string_of_exp f) (string_of_exp g) (string_of_exp h)
	|NotBetAnd(i,j,k) -> Printf.sprintf "%s NOT BETWEEN %s AND %s" (string_of_exp i) (string_of_exp j) (string_of_exp k)
    |IsNull(l) -> Printf.sprintf "%s IS NULL" (string_of_exp l)
    |IsNotNull(m) -> Printf.sprintf "%s IS NOT NULL" (string_of_exp m)

and string_of_sep a = 
	match a with 
	|Eq -> "="
	|Neq -> "<>"
	|Lt -> "<"
	|Gt -> ">"
	|Le -> "<="
	|Ge -> ">="

and string_of_exp a = 
	match a with 
	|Att(b) -> Printf.sprintf "%s" (string_of_attribute b)
	|Parexp(c) -> Printf.sprintf "(%s)" (string_of_exp c)
	|Int i -> string_of_int i 
	|Float f -> string_of_float f
	|String s -> s 
	|Ope(d,e,f) -> Printf.sprintf "%s %s %s " (string_of_exp d) (string_of_op f) (string_of_exp e)
	|Ast(a,v) -> Printf.sprintf "%s * %s " (string_of_exp a) (string_of_exp v)
	|Umi(g) -> Printf.sprintf "-%s" (string_of_exp g)
	|Ppipe(h,i) -> Printf.sprintf "%s || %s" (string_of_exp h) (string_of_exp i)
	|Lower(j) -> Printf.sprintf "LOWER(%s)" (string_of_exp j)
	|Upper(k) -> Printf.sprintf "UPPER(%s)" (string_of_exp k)
	|Substring(l,m,n) -> Printf.sprintf "SUBSTRING(%s FROM %s FOR %s)" (string_of_exp l) (string_of_exp m) (string_of_exp n)

and string_of_attribute a = 
	match a with 
	|Dot(b,c) -> b^"."^c 

and string_of_op a =
	match a with 
	|Plus -> "+"
	|Minus -> "-"
	|Slash -> "/"

(* Evaluateur *)