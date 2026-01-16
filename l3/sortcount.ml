let read_int_list () =
  try
    let line = read_line () |> String.trim in
    if line = "" then []
    else
      line
      |> String.split_on_char ' '
      |> List.filter_map (fun s ->
           let s = String.trim s in
           if s = "" then None
           else
             try Some (int_of_string s)
             with _ -> None
         )
  with End_of_file -> []

let split_list lst =
  let rec aux slow fast acc =
    match fast with
    | [] | [_] -> (List.rev acc, slow)
    | _:: _:: t -> aux (List.tl slow) (List.tl (List.tl fast)) (List.hd slow :: acc)
  in
  aux lst lst []

let merge_and_count l1 l2 =
  let rec aux l1 l2 acc count len1 =
    match l1, l2 with
    | [], ys -> (List.rev_append acc ys, count)
    | xs, [] -> (List.rev_append acc xs, count)
    | x::xs, y::ys ->
        if x <= y then aux xs (y::ys) (x::acc) count (len1 - 1)
        else aux l1 ys (y::acc) (count + len1) len1
  in
  aux l1 l2 [] 0 (List.length l1)

let rec sort_and_count lst =
  match lst with
  | [] | [_] -> (lst, 0)
  | _ ->
      let left, right = split_list lst in
      let sorted_left, cnt_left = sort_and_count left in
      let sorted_right, cnt_right = sort_and_count right in
      let merged, cnt_merge = merge_and_count sorted_left sorted_right in
      (merged, cnt_left + cnt_right + cnt_merge)

let rec print_list lst =
  match lst with
  | [] -> ()
  | [x] -> print_int x
  | x::xs -> print_int x; print_string ", "; print_list xs

let () =
  let nums = read_int_list () in
  let sorted, count = sort_and_count nums in
  Printf.printf "%d\n" count;
  print_string "[";
  print_list sorted;
  print_string "]\n"
