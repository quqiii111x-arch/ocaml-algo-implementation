module FH = FibHeap

(* ---------- Graph & Vertex ---------- *)
type vertex = {
  name : string;
  mutable dist : int;
  mutable prev : string option;
  mutable heap_node : vertex FH.node option;
  mutable in_heap : bool;
  mutable neighbors : (vertex * int) list;
}

type graph = {
  vertices : (string, vertex) Hashtbl.t;
}

(* ---------- Input ---------- *)
let read_input () =
  let edge_num = read_int () in
  let vertices = Hashtbl.create 50 in
  for _ = 1 to edge_num do
    match String.split_on_char ' ' (read_line ()) with
    | [u; v; w] ->
      let w = int_of_string w in
      let vu = if Hashtbl.mem vertices u then Hashtbl.find vertices u
               else let vtx = { name=u; dist=max_int; prev=None;
                                 heap_node=None; in_heap=false; neighbors=[] } in
                    Hashtbl.add vertices u vtx; vtx
      in
      let vv = if Hashtbl.mem vertices v then Hashtbl.find vertices v
               else let vtx = { name=v; dist=max_int; prev=None;
                                 heap_node=None; in_heap=false; neighbors=[] } in
                    Hashtbl.add vertices v vtx; vtx
      in
      vu.neighbors <- (vv,w)::vu.neighbors
    | _ -> failwith "Invalid edge format"
  done;
  let start_node = read_line () in
  let end_node = read_line () in
  ({ vertices }, start_node, end_node)

(* ---------- Path Reconstruction ---------- *)
let reconstruct_path vertices start_name end_name =
  let rec build_path cur acc =
    match cur with
    | None -> acc
    | Some n -> build_path (Hashtbl.find vertices n).prev (n::acc)
  in
  let path = build_path (Some end_name) [] in
  match path with
  | [] -> ["Invalid!"]
  | h::_ -> if h = start_name then path else ["Invalid!"]

(* ---------- Dijkstra with optimized lazy insert ---------- *)
let dijkstra g start_name end_name =
  let heap = FH.makeHeap () in

  let start_v = Hashtbl.find g.vertices start_name in
  start_v.dist <- 0;
  start_v.heap_node <- Some (FH.insert heap ~key:0 ~value:start_v);
  start_v.in_heap <- true;

  while not (FH.isEmpty heap) do
    match FH.extractMin heap with
    | None -> ()
    | Some (_, u) ->
      if u.in_heap then begin
        u.in_heap <- false;
        u.heap_node <- None;

        List.iter (fun (v, w) ->
          let alt = u.dist + w in
          if alt < v.dist then begin
            v.dist <- alt;
            v.prev <- Some u.name;

            match v.heap_node with
            | Some node when v.in_heap -> FH.decreaseKey heap node alt
            | Some _ -> ()   
            | None ->       
              let node = FH.insert heap ~key:alt ~value:v in
              v.heap_node <- Some node;
              v.in_heap <- true

          end
        ) u.neighbors
      end
  done;

  let end_v = Hashtbl.find g.vertices end_name in
  if end_v.dist = max_int then ["Invalid!"]
  else reconstruct_path g.vertices start_name end_name

(* ---------- Main ---------- *)
let () =
  let g, start_node, end_node = read_input () in
  let path = dijkstra g start_node end_node in
  if path = ["Invalid!"] then
    Printf.printf "Invalid!\n"
  else
    let s = String.concat "', '" path in
    Printf.printf "['%s']\n" s
