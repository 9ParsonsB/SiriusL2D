Timer = {
  List = {}
}

function Timer.Update(dt)
  for k,v in pairs(Timer.List) do
    v.Active = false
    v.Time = v.Time - dt

    if v.Time <= 0 then 
      v.Time = v.Interval
      v.Active = true
    end
  end
end

function Timer.Create(interval)
  local timer = {Time = interval, Interval = interval, Active = false}
  table.insert(Timer.List, timer)
  return timer
end