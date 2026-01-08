local string2 = {}

function string2.subst(str, i, length, replacement)
  return str:sub(1, i - 1) .. replacement .. str:sub(i + length, #str)
end

return string2
