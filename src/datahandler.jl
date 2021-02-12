function read_gacha(sheetname)
    f = "$PATH\\data\\gacha.xlsx"
    df = DataFrame(XLSX.readtable(f, sheetname)...)
    d = Dict{Symbol, Tuple}()

    for gdf in groupby(df, :구분)
        wv = convert(Vector{Float64}, collect(gdf[!, :확률]))
        d[Symbol(gdf[1, :구분])] = (gdf[!, :Id], pweights(wv))
    end
    return d
end

function read_gamedata(sheetname)
    f = "$PATH\\data\\gamedata.xlsx"
    df = DataFrame(XLSX.readtable(f, sheetname)...)
    df[!, "옵션"] = Array{Union{Array, Missing}, 1}(missing, size(df, 1))

    deletetargets = Int[]
    idx = 1
    for i in 1:size(df, 1)
        if isa(df[i, "Id"], Integer)
            idx = i 
            df[idx, "옵션"] = []
        else 
            push!(df[idx, "옵션"], df[i, "이름/옵션"])
            push!(deletetargets, i)
        end
    end
    delete!(df, deletetargets)

    return df
end
