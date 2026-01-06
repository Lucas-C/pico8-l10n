#!/usr/local/bin/lua

local argparse = require("argparse")

print("These are the arguments from varargs")
print(...)

print("These are the arguments from arg")
for i=0,#arg do
	print(i,arg[i])
end

print("These are the libraries")
for k,v in pairs(_G) do
	if type(v)=="table" then io.write(k,',') end
end
io.write('\n')
