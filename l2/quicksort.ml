let quicksort arr =
  let swap i j =
    let temp = arr.(i) in
    arr.(i) <- arr.(j);
    arr.(j) <- temp
  in
  let rec sort low high =
    if low >= high then () else
      let pivot_index = low + Random.int (high - low + 1) in
      let pivot_value = arr.(pivot_index) in
      swap low pivot_index;  

      let smaller_end = ref low in    
      let larger_start = ref high in  
      let current = ref (low + 1) in

      while !current <= !larger_start do
        if arr.(!current) < pivot_value then (
          swap !smaller_end !current;
          incr smaller_end;
          incr current
        ) else if arr.(!current) > pivot_value then (
          swap !current !larger_start;
          decr larger_start
        ) else
          incr current
      done;

      sort low (!smaller_end - 1);
      sort (!larger_start + 1) high
  in
  sort 0 (Array.length arr - 1)


let () =
  Random.self_init ();
  let line = read_line () in
  let arr =
    line
    |> String.split_on_char ','
    |> Array.of_list
    |> Array.map String.trim
    |> Array.map int_of_string
  in
  quicksort arr;
  Array.iter (Printf.printf "%d ") arr;
  print_newline ()

