function read_gacha(sheetname)
    f = "$PATH\\data\\gacha.xlsx"
    df = readxlsheet(DataFrame, f, sheetname)
    d = Dict{Symbol, Tuple}()

    # 이름을 id로 전환. gacha.xlsx의 한글명과 gamedata.xlsx의 한글명이 일치해야 함.
    id_ref = sheetname == "magicaldoll" ? MAGICALDOLL_NAME : TRANSFORMCARD_NAME
    idx = indexin(df[:종류], collect(values(id_ref)))
    df[:id] = collect(keys(id_ref))[idx]

    for ref in groupby(df, :구분)
        indexin(df[:종류], collect(values(MAGICALDOLL_NAME)))
        d[Symbol(ref[1, :구분])] = (ref[:id], Weights(ref[:확률]))
    end
    return d
end

function read_gamedata(sheetname)
    f = "$PATH\\data\\gamedata.xlsx"
    rawdata = readxlsheet(f, sheetname)
    rawdata = rawdata[2:end, :] # 컬럼명 제외

    # 데이터 범위 찾기
    rg = Range[]
    st = 0
    for i in 1:size(rawdata, 1)
        x = rawdata[i, 1]
        if !isna(x) && st == 0
            st = i
        elseif (isna(x) && st != 0) || i == size(rawdata, 1)
            push!(rg, st:(i-1))
            st = 0
        end
    end

    # 데이터 프레임에 저장
    df = DataFrame(id = UInt8.(collect(1:length(rg))))
    begin
        st = start.(rg)
        df[:name] = rawdata[st, 1]
        df[:grade] = convert(Vector{Int8}, rawdata[st, 2])
        sheetname == "transformcard" && (df[:job] = rawdata[st, 3])
    end
    # TODO: 옵션 파싱 필요
    df[:option] = map(x->rawdata[first(x)+1:last(x), 1], rg)

    return df
end
#
# function parse_option(s::String)
#
# end
# function read_collectiondata()
#
#
# end
