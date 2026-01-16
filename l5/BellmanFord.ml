open Printf

type edge = {
  u : string;
  v : string;
  w : int;
}

let read_input () =
  let edge_num = read_int () in
  let edges = ref [] in
  for _ = 1 to edge_num do
    let line = read_line () in
    match String.split_on_char ' ' line with
    | [u; v; w] -> edges := {u; v; w=int_of_string w} :: !edges
    | _ -> failwith "Invalid edge format"
  done;
  let start_node = read_line () in
  let end_node = read_line () in
  (!edges, start_node, end_node)

let vertices_of_edges edges =
  let vertex_set = Hashtbl.create 16 in
  List.iter (fun e ->
      Hashtbl.replace vertex_set e.u ();
      Hashtbl.replace vertex_set e.v ();
    ) edges;
  Hashtbl.fold (fun k _ acc -> k :: acc) vertex_set []

let bellman_ford edges start =
  let vertices = vertices_of_edges edges in
  let dist = Hashtbl.create 16 in
  let prev = Hashtbl.create 16 in
  List.iter (fun v -> Hashtbl.add dist v max_int) vertices;
  Hashtbl.replace dist start 0;

  for _ = 1 to List.length vertices - 1 do
    List.iter (fun e ->
        let du = Hashtbl.find dist e.u in
        let dv = Hashtbl.find dist e.v in
        if du <> max_int && du + e.w < dv then begin
          Hashtbl.replace dist e.v (du + e.w);
          Hashtbl.replace prev e.v e.u;
        end
      ) edges
  done;

  (* Check negative cycles *)
  let has_negative_cycle =
    List.exists (fun e ->
        let du = Hashtbl.find dist e.u in
        let dv = Hashtbl.find dist e.v in
        du <> max_int && du + e.w < dv
      ) edges
  in
  if has_negative_cycle then begin
    Printf.printf "Invalid!\n";
    exit 0   
  end;

  (dist, prev)

let reconstruct_path prev start goal =
  let rec aux v acc =
    if v = start then start :: acc
    else match Hashtbl.find_opt prev v with
      | Some u -> aux u (v :: acc)
      | None -> []  
  in
  aux goal []

(* Main *)
let () =
  let edges, start_node, end_node = read_input () in
  let edges_list = edges in  
  let _, prev = bellman_ford edges_list start_node in
  let path = reconstruct_path prev start_node end_node in
  let path_str = path |> List.map (fun s -> "'" ^ s ^ "'") |> String.concat ", " in
  printf "[%s]\n" path_str


