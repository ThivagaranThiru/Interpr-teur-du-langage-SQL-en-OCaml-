type simple_query

type projection

type projection_bis

type column

type source

type joinop

type condition

type boolean

type predicate

type sep

type expr

type attribute

type operation

val squery : projection -> source -> condition -> simple_query

val asterix : projection

val pro : projection_bis -> projection

val col : column -> projection_bis

val col2 : column -> projection_bis -> projection_bis

val ex : expr -> column

val exid : expr -> string -> column 

val id : string -> source 

val query : simple_query -> source 

val coma : source -> source -> source 

val crossjoIn : source -> source -> source 

val joinOp : source -> joinop -> source -> condition -> source

val join : joinop

val innerjoin : joinop

val leftjoin : joinop

val leftouterjoin : joinop

val rightjoin : joinop

val rightouterjoin : joinop

val fulljoin : joinop

val fullouterjoin : joinop

val pred : predicate -> condition 

val not : condition -> condition 

val anD : condition -> condition -> condition 

val oR  : condition -> condition -> condition 

val is : condition -> boolean -> condition 

val isnot : condition -> boolean -> condition

val trUe : boolean 

val falSe : boolean 

val unknoWn : boolean 

val par : condition -> predicate 

val seP : expr -> expr -> sep -> predicate 

val betand : expr -> expr -> expr -> predicate 

val notbetand : expr -> expr -> expr -> predicate 

val isnull : expr -> predicate

val isnotnull : expr -> predicate 

val eq : sep

val neq : sep

val lt : sep

val gt : sep

val le : sep

val ge : sep

val att : attribute -> expr

val parexp : expr -> expr

val inT : int -> expr 

val floaT : float -> expr

val strinG : string -> expr 

val ope : expr -> expr -> operation -> expr 

val umi : expr -> expr 

val ppipe : expr -> expr -> expr 

val lower : expr -> expr 

val upper : expr -> expr 

val substring : expr -> expr -> expr -> expr 

val dot : string -> string -> attribute

val plus : operation 

val minus : operation 

val asterix : operation 

val slash : operation

val string_of_simple_query : simple_query -> string 

val string_of_projection : projection -> string 

val string_of_projection_bis : projection_bis -> string

val string_of_column : column -> string 

val string_of_source : source -> string 

val string_of_joinop : joinop -> string 

val string_of_condition : condition -> string 

val string_of_booleAn : boolean -> string 

val string_of_predicate : predicate -> string

val string_of_sep : sep -> string 

val string_of_exp : expr -> string 

val string_of_attribute : attribute -> string

val string_of_op : operation -> string 


