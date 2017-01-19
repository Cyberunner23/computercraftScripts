args = {...}
 
function loadAPIs(APIListToLoad)
        APIList = {
                ["PATH"] = APIListToLoad or "rom/apis/turtle/turtle",
                ["NAME"] =  nil,
                ["API"] = nil
        }
        APIList["NAME"] = fs.getName(APIList["PATH"])
        os.loadAPI(APIList["PATH"])
        APIList["API"] = _G[APIList["NAME"]]
end
 
function runProgram(program, loops)
        if program[1] == "set" then
                table.remove(program, 1)
                program["NAME"] = program[1]
                table.remove(program, 1)
 
        elseif program["NAME"] then
 
        else
                program["NAME"] = "MAIN"
        end
 
print("\nExecuting: ", program["NAME"], " of length ", #program, ", ", loops, " times")
        while loops > 0 do
                loops = loops - 1
 
                program["COUNT"] = 0
                depth = 0
                while program["COUNT"] < #program do
                        program["COUNT"] = program["COUNT"] + 1
print(" ", program["NAME"], " >[count] ", program["COUNT"], " ( ", program[program["COUNT"]], " )")
                        if type(program[program["COUNT"]]) == "table" then
                                if tonumber(program[program["COUNT"] + 1]) then
                                        runProgram(program[program["COUNT"]], tonumber(program[program["COUNT"] + 1]))
                                        program["COUNT"] = program["COUNT"] + 1
                                else
                                        runProgram(program[program["COUNT"]], 1)
                                end
 
                        elseif program[program["COUNT"]] == "(" then
                                depth = depth + 1
                                program[program["COUNT"]] = {}
 
                                if program[program["COUNT"] + 1] == "set" then
                                        table.insert(program[program["COUNT"]], table.remove(program, program["COUNT"]+1))
                                        program[program["COUNT"]]["NAME"] = program[program["COUNT"] + 1] .. program["NAME"]
                                        table.insert(program[program["COUNT"]], table.remove(program, program["COUNT"] + 1))
 
                                else
                                        table.insert(program[program["COUNT"]], "set")
                                        table.insert(program[program["COUNT"]], program["NAME"] .. " >] " .. tostring(program["COUNT"]))
                                end
 
--print("\nNew SubProgram: ", program[program["COUNT"]]["NAME"])
--print("DEPTH: ", depth)
 
                                while depth ~= 0 and program["COUNT"] < #program do
                                        if program[program["COUNT"] + 1] == "(" then
                                                depth = depth + 1
                                                table.insert(program[program["COUNT"]], table.remove(program, program["COUNT"] + 1))
--print("DEPTH: ", depth)
 
                                        elseif program[program["COUNT"] + 1] == ")" then
                                                depth = depth - 1
--print("DEPTH: ", depth)
                                                if depth == 0 then
                                                        table.remove(program, program["COUNT"] + 1)
 
                                                else
                                                        table.insert(program[program["COUNT"]], table.remove(program, program["COUNT"] + 1))
                                                end
                                                       
                                        else
                                                table.insert(program[program["COUNT"]], table.remove(program, program["COUNT"] + 1))
                                        end
                                end
 
                                if tonumber(program[program["COUNT"] + 1]) then
                                        program[program["COUNT"]] = runProgram(program[program["COUNT"]], tonumber(program[program["COUNT"] + 1]))
                                        program["COUNT"] = program["COUNT"] + 1
                                else
                                        program[program["COUNT"]] = runProgram(program[program["COUNT"]], 1)
                                end
 
                        elseif program[program["COUNT"]] == ")" then
                                print("\n\nFound \")\" when not in a sub-program, maybe missing a space at \"(\"?")
                                break
 
                        elseif APIList["API"][program[program["COUNT"]]] then
                                if tonumber(program[program["COUNT"] + 1]) then
                                        program["COUNT"] = program["COUNT"] + 1
print("    ", program["NAME"], " [-", program[program["COUNT"]], "-> ", APIList["NAME"], ".", program[program["COUNT"]-1], "()")
                                        for i=1,tonumber(program[program["COUNT"]]) do
                                                APIList["API"][program[program["COUNT"]-1]]()
                                        end
 
                                else
print(program["NAME"], " [-> ", APIList["NAME"], ".", program[program["COUNT"]], "()")
                                        APIList["API"][program[program["COUNT"]]]()
                                end
 
                        elseif tonumber(program[program["COUNT"]]) then
print("\tNumber: ", program[program["COUNT"]])
 
                        else
                                os.run( {}, tostring(program[program["COUNT"]]))
                        end
--os.pullEvent( "key" )
                end
        end
 
        program["COUNT"] = nil
        return program
 
end
 
loadAPIs()
 
print( "API(", APIList["API"], ");")
print("\tName: ", APIList["NAME"])
print( "\tPath: ", APIList["PATH"])
 
runProgram(args, 1)
