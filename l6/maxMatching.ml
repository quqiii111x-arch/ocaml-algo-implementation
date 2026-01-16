let () =
  let n = read_int () in
  let m = read_int () in

  let adj = Array.make n [] in
  for _ = 1 to m do
    let line = read_line () |> String.trim in
    let u, v =
      match String.split_on_char ' ' line |> List.filter ((<>) "") with
      | [a; b] -> int_of_string a, int_of_string b
      | _ -> failwith "Invalid"
    in
    adj.(u) <- v :: adj.(u)
  done;

  let inf = 1 lsl 30 in
  let pair_u = Array.make n (-1) in
  let pair_v = Array.make n (-1) in
  let dist = Array.make n 0 in

  let bfs () =
    let q = Queue.create () in
    for u = 0 to n-1 do
      if pair_u.(u) = -1 then (dist.(u) <- 0; Queue.push u q)
      else dist.(u) <- inf
    done;
    while not (Queue.is_empty q) do
      let u = Queue.pop q in
      List.iter (fun v ->
        let pu = pair_v.(v) in
        if pu <> -1 && dist.(pu) = inf then begin
          dist.(pu) <- dist.(u) + 1;
          Queue.push pu q
        end;
      ) adj.(u)
    done;
    ()
  in

  let rec dfs u =
    List.exists (fun v ->
      let pu = pair_v.(v) in
      if pu = -1 || (dist.(pu) = dist.(u) + 1 && dfs pu) then begin
        pair_u.(u) <- v;
        pair_v.(v) <- u;
        true
      end else false
    ) adj.(u)
  in

  let matching = ref 0 in
  let rec loop () =
    bfs ();
    let progress = ref false in
    for u = 0 to n-1 do
      if pair_u.(u) = -1 && dfs u then begin
        incr matching;
        progress := true
      end
    done;
    if !progress then loop ()
  in

  loop ();
  print_int !matching;
  print_newline ();
