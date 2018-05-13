
let _ =

  (* Ouverture un flot de caractère ; ici à partir de l'entrée standard *)  
  let source = Lexing.from_channel stdin in

  (* Boucle infinie interompue par une exception correspondant à la fin de fichier *)
  let rec f () =
    try
      (* Récupération d'une expression à partir de la source puis affichage de l'évaluation *)
      let e = Parser.ansyn Lexer.anlex source in
      Printf.printf "%s => %i\n" (Ast.string_of_expr e) (Ast.eval e); flush stdout;
      f ()
    with Lexer.Eof -> Printf.printf "Bye\n"
  in

  f ()

