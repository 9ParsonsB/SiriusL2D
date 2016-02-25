--[[ FROM: http://lua-users.org/wiki/SaveTableToFile
Save Table to File
Load Table from File
v 1.0

Lua 5.2 compatible

Only Saves Tables, Numbers and Strings
Insides Table References are saved
Does not save Userdata, Metatables, Functions and indices of these
----------------------------------------------------
table.save( table , filename )

on failure: returns an error msg

----------------------------------------------------
table.load( filename or stringtable )

Loads a table that has been saved via the table.save function

on success: returns a previously saved table
on failure: returns as second argument an error msg
----------------------------------------------------

Licensed under the same terms as Lua itself.
]]--
do
-- declare local variables
--// exportstring( string )
--// returns a "Lua" portable version of the string
local function exportstring( s )
  return string.format("%q", s)
end

--// The Save Function
function table.serialize(  tbl)
  local result = ""
  local charS,charE = "   ","\n"
  if not tbl then return end


  local tables,lookup = { tbl },{ [tbl] = 1 } -- initiate variables for save procedure
  result = result .. "return {} "

  for idx,t in ipairs( tables ) do
    result = result .. "-- Table: {"..idx.."}:"..charE
    result = result .. "{"..charE 
    local thandled = {}

    for i,v in ipairs( t ) do
      if i == 1 or i == #t then 
        charE = ""
      else
        charE = ","
      end
      thandled[i] = true
      local stype = type( v )

      if stype == "table" then -- only handle value
        if not lookup[v] then
          table.insert( tables, v )
          lookup[v] = #tables
        end
        result = result .. (charS.."{"..lookup[v].."},"..charE )
      elseif stype == "string" then
        result = result .. (charS..exportstring( v )..","..charE )
      elseif stype == "number" then
        result = result .. ( charS..tostring( v )..","..charE )
      end
    end

    for i,v in pairs( t ) do
      if i == 1 or i == #t then 
        charE = ""
      else
        charE = ","
      end
      if (not thandled[i]) then -- escape handled values

        local str = ""
        local stype = type( i )

        if stype == "table" then -- handle index
          if not lookup[i] then
            table.insert( tables,i )
            lookup[i] = #tables
          end
          str = charS.."[{"..lookup[i].."}]="
        elseif stype == "string" then
          str = charS.."["..exportstring( i ).."]="
        elseif stype == "number" then
          str = charS.."["..tostring( i ).."]="
        end

        if str ~= "" then
          stype = type( v )
          if stype == "table" then -- handle value
            if not lookup[v] then
              table.insert( tables,v )
              lookup[v] = #tables
            end
            result = result .. ( ",".. charE .. str.."{"..lookup[v].."}")
          elseif stype == "string" then
            result = result .. ( "," .. charE .. str..exportstring( v ) )
          elseif stype == "number" then
            result = result .. ( "," .. charE .. str..tostring( v ) )
          end
        end
      end
    end
    result = result .. (charE.. "}" )
  end
  result = result .. ( "}" )
  return result
end


function table.load( istring )--// The Load Function
  local ftables,err = loadstring( istring )
  if err then return _,err end
  local tables = ftables()
  for idx = 1,#tables do
    local tolinki = {}
    for i,v in pairs( tables[idx] ) do
      if type( v ) == "table" then
        tables[idx][i] = tables[v[1]]
      end
      if type( i ) == "table" and tables[i[1]] then
        table.insert( tolinki,{ i,tables[i[1]] } )
      end
    end

for _,v in ipairs( tolinki ) do-- link indices
  tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
end
end
return tables[1]
end

end-- close do