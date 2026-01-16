module type ORDERED = sig
  type t

  val compare : t -> t -> int

  val hash : t -> int

  val equal : t -> t -> bool
end

module Make (K : ORDERED) (W : sig type t end) = struct
  module KeyMap = Map.Make(struct
    type t = K.t
    let compare = K.compare
  end)

  type key = K.t
  type weight = W.t

  type 'a t = {
    vertices : ('a * (weight KeyMap.t)) KeyMap.t;
  }

  let empty () = { vertices = KeyMap.empty }

  let add_vertex v data g =
    if KeyMap.mem v g.vertices then g
    else { vertices = KeyMap.add v (data, KeyMap.empty) g.vertices }

  let get_vertex_value v g =
    match KeyMap.find_opt v g.vertices with
    | Some (data, _) -> Some data
    | None -> None

  let set_vertex_value v data g =
    match KeyMap.find_opt v g.vertices with
    | Some (_, edges) -> { vertices = KeyMap.add v (data, edges) g.vertices }
    | None -> g

  let is_adjacent u v g =
    match KeyMap.find_opt u g.vertices with
    | Some (_, edges) -> KeyMap.mem v edges
    | None -> false

  let get_edge_weight u v g =
    match KeyMap.find_opt u g.vertices with
    | Some (_, edges) -> KeyMap.find_opt v edges
    | None -> None

  let add_edge u v w g =
    if KeyMap.mem u g.vertices && KeyMap.mem v g.vertices then
      let add_one u v g =
        match KeyMap.find_opt u g.vertices with
        | Some (data, edges) ->
            if KeyMap.mem v edges then g
            else { vertices = KeyMap.add u (data, KeyMap.add v w edges) g.vertices }
        | None -> g
      in
      g |> add_one u v |> add_one v u
    else g

  let remove_edge u v g =
    let remove_one u v g =
      match KeyMap.find_opt u g.vertices with
      | Some (data, edges) ->
          { vertices = KeyMap.add u (data, KeyMap.remove v edges) g.vertices }
      | None -> g
    in
    g |> remove_one u v |> remove_one v u

  let remove_vertex v g =
    let g1 = { vertices = KeyMap.remove v g.vertices } in
    let g2 =
      KeyMap.fold (fun u (data, edges) acc ->
        let new_edges = KeyMap.remove v edges in
        { vertices = KeyMap.add u (data, new_edges) acc.vertices }
      ) g1.vertices g1
    in
    g2

  let set_edge_weight u v w g =
    if KeyMap.mem u g.vertices && KeyMap.mem v g.vertices then
      let set_one u v g =
        match KeyMap.find_opt u g.vertices with
        | Some (data, edges) ->
            if KeyMap.mem v edges then
              { vertices = KeyMap.add u (data, KeyMap.add v w edges) g.vertices }
            else g
        | None -> g
      in
      g |> set_one u v |> set_one v u
    else g
end
