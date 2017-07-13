function opengacha(table::Symbol, grade::Symbol)
    ref = GAMEDATA[table][grade]
    sample(ref[1], ref[2])
end
