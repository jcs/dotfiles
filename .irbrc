def history(num=100)
  h = Readline::HISTORY.to_a
  start = [0,h.size-num-1].max
  h.zip((0..h.size).to_a)[start...h.size].each do |cmd,i|
    puts " #{(i).to_s.rjust(4)}  #{cmd}"
  end
end
