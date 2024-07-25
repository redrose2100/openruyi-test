(* my_program.ml *)

(* Define a function to calculate the factorial of a number *)
let rec factorial n =
  if n <= 1 then 1
  else n * factorial (n - 1)

(* Define the main function to demonstrate the factorial function *)
let () =
  let num = 5 in  (* Compute factorial of 5 *)
  let result = factorial num in
  print_endline ("Factorial of " ^ string_of_int num ^ " is " ^ string_of_int result)
