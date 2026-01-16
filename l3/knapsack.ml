let read_input () =
  let s = read_int () in
  let lst = read_line () 
            |> String.split_on_char ' ' 
            |> List.filter_map (fun x -> if x = "" then None else Some (int_of_string x)) 
  in
  s, lst

(* 1 *)
let smallest_first s lst =
  let sorted = List.sort compare lst in
  let rec aux sum acc = function
    | [] -> if sum = 0 then Some (List.sort compare acc) else None
    | x::xs ->
        if x <= sum then aux (sum - x) (x::acc) xs
        else aux sum acc xs
  in aux s [] sorted

(* 2 *)
let largest_first s lst =
  let sorted = List.sort (fun a b -> compare b a) lst in
  let rec aux sum acc = function
    | [] -> if sum = 0 then Some (List.sort compare acc) else None
    | x::xs ->
        if x <= sum then aux (sum - x) (x::acc) xs
        else aux sum acc xs
  in aux s [] sorted

(* dp *)
let dp_knapsack s lst =
  let tbl = Array.make (s+1) None in
  tbl.(0) <- Some [];
  List.iter (fun x ->
      for j = s downto x do
        match tbl.(j-x), tbl.(j) with
        | Some l, None -> tbl.(j) <- Some (x::l)
        | _ -> ()
      done
  ) lst;
  match tbl.(s) with
  | Some l -> Some (List.sort compare l)
  | None -> None


let print_result = function
  | None -> Printf.printf "No solution\n"
  | Some l -> Printf.printf "[%s]\n" (String.concat ", " (List.map string_of_int l))

let time f x =
  let t1 = Sys.time () in
  let r = f x in
  let t2 = Sys.time () in
  r, (t2 -. t1)

let counterexample () =
  let s = 7 in
  let lst = [1;3;4;5] in
  Printf.printf "Counterexample: S=%d, list=[1;3;4;5]\n" s;
  let r1 = smallest_first s lst in
  Printf.printf "Smallest-first: "; print_result r1;
  let r2 = largest_first s lst in
  Printf.printf "Largest-first: "; print_result r2;
  let r3 = dp_knapsack s lst in
  Printf.printf "DP solution: "; print_result r3



let benchmark_table () =
  let input_sizes = [10; 20; 30; 40; 50; 100; 1000; 10000] in
  List.iter (fun n ->
      let lst = List.init n (fun i -> i+1) in
      let s = n in 
      Printf.printf "\nBenchmark: n=%d, S=%d\n" n s;

      let _r1, t1 = time (fun () -> smallest_first s lst) () in
      Printf.printf "Smallest-first: %fs\n" t1;

      let _r2, t2 = time (fun () -> largest_first s lst) () in
      Printf.printf "Largest-first: %fs\n" t2;

      let _r3, t3 = time (fun () -> dp_knapsack s lst) () in
      Printf.printf "DP solution: %fs\n" t3
  ) input_sizes;;

  
let main () =
  let s, lst = read_input () in
  match dp_knapsack s lst with
  | None -> ()
  | Some l -> Printf.printf "[%s]\n" (String.concat ", " (List.map string_of_int l))

let () = main ()
