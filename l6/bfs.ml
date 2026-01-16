let () =
  let m = read_int () in

  let adj = Hashtbl.create 100 in

  let add_edge u v =
    let lst = try Hashtbl.find adj u with Not_found -> [] in
    Hashtbl.replace adj u (lst @ [v])
  in

  for _ = 1 to m do
    let line = read_line () in
    let u, v =
      match String.split_on_char ' ' line |> List.filter (fun x -> x <> "") with
      | [a; b] -> int_of_string a, int_of_string b
      | _ -> failwith "Invalid edge"
    in
    add_edge u v;
    add_edge v u; 
  done;

  (* BFS *)
  let visited = Hashtbl.create 100 in
  let q = Queue.create () in
  Queue.push 0 q;
  Hashtbl.add visited 0 true;

  let result = ref [] in

  while not (Queue.is_empty q) do
    let u = Queue.pop q in
    result := !result @ [u];
    let neighbors =
      try Hashtbl.find adj u with Not_found -> []
    in
    List.iter (fun v ->
      if not (Hashtbl.mem visited v) then begin
        Hashtbl.add visited v true;
        Queue.push v q;
      end
    ) neighbors
  done;

  print_endline (String.concat " " (List.map string_of_int !result))
