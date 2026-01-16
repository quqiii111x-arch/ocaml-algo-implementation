let read_int_list () =
  read_line ()
  |> String.split_on_char ' '
  |> List.filter_map (fun s ->
       let s = String.trim s in
       if s = "" then None
       else Some (int_of_string s))

let topological_sort n edges =
  let adj = Array.make n [] in
  let indegree = Array.make n 0 in

  List.iter (fun (u, v) ->
    adj.(u) <- v :: adj.(u);
    indegree.(v) <- indegree.(v) + 1
  ) edges;

  let queue = Queue.create () in
  for i = 0 to n - 1 do
    if indegree.(i) = 0 then Queue.add i queue
  done;

  let result = ref [] in

  while not (Queue.is_empty queue) do
    let u = Queue.pop queue in
    result := u :: !result;
    List.iter (fun v ->
      indegree.(v) <- indegree.(v) - 1;
      if indegree.(v) = 0 then Queue.add v queue
    ) adj.(u)
  done;

  List.rev !result

let () =
  let n = read_int () in
  let m = read_int () in
  let edges =
    List.init m (fun _ ->
      match read_int_list () with
      | [u; v] -> (u, v)
      | _ -> failwith "Invalid edge input"
    )
  in
  let sorted = topological_sort n edges in
  sorted
  |> List.map string_of_int
  |> String.concat " "
  |> print_endline
