(* EdmondsKarp.ml *)

module SMap = Map.Make(String)

(* Add capacity to adjacency and capacity table *)
let add_edge graph cap u v w =
  let lst = try SMap.find u graph with Not_found -> [] in
  let graph = SMap.add u (v :: lst) graph in
  let key = (u, v) in
  let cap = Hashtbl.replace cap key w; cap in
  graph, cap

let get_cap cap u v =
  try Hashtbl.find cap (u, v) with Not_found -> 0

let set_cap cap u v w =
  Hashtbl.replace cap (u, v) w

let () =
  let m = read_int () in
  let graph = ref SMap.empty in
  let cap = Hashtbl.create 100 in

  for _ = 1 to m do
    let line = read_line () in
    let parts = String.split_on_char ' ' line |> List.filter ((<>) "") in
    match parts with
    | [u; v; w] ->
        let w = int_of_string w in
        graph := fst (add_edge !graph cap u v w);
        if get_cap cap v u = 0 then begin
          graph := fst (add_edge !graph cap v u 0)
        end
    | _ -> failwith "Invalid input"
  done;

  let source = read_line () in
  let sink = read_line () in

  let max_flow = ref 0 in

  let bfs () =
    let q = Queue.create () in
    let parent = Hashtbl.create 100 in
    Queue.push source q;
    Hashtbl.add parent source "";

    let found = ref false in
    while not (Queue.is_empty q) && not !found do
      let u = Queue.pop q in
      let neighbors = try SMap.find u !graph with Not_found -> [] in
      List.iter (fun v ->
        if not (Hashtbl.mem parent v) && get_cap cap u v > 0 then begin
          Hashtbl.add parent v u;
          if v = sink then found := true;
          Queue.push v q
        end
      ) neighbors
    done;

    if not (Hashtbl.mem parent sink) then None
    else Some parent
  in

  let rec augment () =
    match bfs () with
    | None -> ()
    | Some parent ->
      let rec find_min v acc =
        if v = source then acc
        else
          let u = Hashtbl.find parent v in
          let c = get_cap cap u v in
          let acc = min acc c in
          find_min u acc
      in
      let bottleneck = find_min sink max_int in

      let rec update v =
        if v <> source then
          let u = Hashtbl.find parent v in
          set_cap cap u v (get_cap cap u v - bottleneck);
          set_cap cap v u (get_cap cap v u + bottleneck);
          update u
      in
      update sink;

      max_flow := !max_flow + bottleneck;
      augment ()
  in

  augment ();
  print_int !max_flow;
  print_newline ();
