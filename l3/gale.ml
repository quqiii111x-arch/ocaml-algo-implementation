let read_int_list () =
  read_line ()
  |> String.split_on_char ' '
  |> List.filter (fun s -> s <> "")
  |> List.map int_of_string

let () =
  let n = read_int () in
  let men_prefs = Array.init n (fun _ -> read_int_list ()) in
  ignore (read_line ());  
  let women_prefs = Array.init n (fun _ -> read_int_list ()) in

  let women_rank = Array.init n (fun _ -> Array.make n 0) in
  for w = 0 to n - 1 do
    List.iteri (fun rank man -> women_rank.(w).(man) <- rank) women_prefs.(w)
  done;


  let man_partner = Array.make n (-1) in   
  let woman_partner = Array.make n (-1) in
  let man_next = Array.make n 0 in        
  let free_men = Queue.create () in
  for m = 0 to n - 1 do Queue.add m free_men done;


  while not (Queue.is_empty free_men) do
    let m = Queue.take free_men in              
    let w = List.nth men_prefs.(m) man_next.(m) in
    man_next.(m) <- man_next.(m) + 1;             

    if woman_partner.(w) = -1 then (
      man_partner.(m) <- w;
      woman_partner.(w) <- m;
    ) else (
      let m' = woman_partner.(w) in
      if women_rank.(w).(m') < women_rank.(w).(m) then (
        Queue.add m free_men
      ) else (
        man_partner.(m) <- w;
        woman_partner.(w) <- m;
        man_partner.(m') <- -1;
        Queue.add m' free_men
      )
    )
  done;


  let pairs =
    Array.mapi (fun m w -> Printf.sprintf "[%d, %d]" m w) man_partner
    |> Array.to_list
    |> String.concat ", "
  in
  Printf.printf "[%s]\n" pairs


