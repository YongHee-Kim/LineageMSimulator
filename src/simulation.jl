function montecarlo_simulation(상자등급 = :상급)
    ac = 계정()

    history = Dict("첫고급"=>0, "모든고급"=>0, "첫희귀"=>0, "모든희귀"=>0,
                "첫영웅"=>0, "모든영웅"=>0, "첫전설"=>0, "모든전설"=>0)
    history_compose = Dict{String, Vector{Int}}()
    n = 0
    while true
        n += 1
        cardid = opengacha(:Gacha_TransformCard, 상자등급)
        # 리턴값이 false면 합성 시도
        r = addcard!(ac, cardid)
        if !r
            compose_card!(ac)
        end

        for grade in ("고급", "희귀", "영웅")
            if history["첫$grade"] == 0
                x = getfield(ac.카드, Symbol(grade))
                if any(values(x))
                    history["첫$grade"] = n
                    history_compose["첫$grade"] = deepcopy(ac.카드.합성시도횟수)
                end
            end
            if history["모든$grade"] == 0
                x = getfield(ac.카드, Symbol(grade))
                if all(values(x))
                    history["모든$grade"] = n
                    history_compose["모든$grade"] = deepcopy(ac.카드.합성시도횟수)
                end
            end
        end

        if history["첫전설"] == 0
            x = getfield(ac.카드, :전설)
            if any(values(x))
                history["첫전설"] = n
                history_compose["첫전설"] = deepcopy(ac.카드.합성시도횟수)
                break
            end
        end
    end
    return history, history_compose
end


"""
    simulation(gacha_grace, n = 10000)

n회동안 전설 나올떄까지 가챠 뽑아서 합성하기

1. 합성시 상위 카드 등장확률은 유저의 연구자료를 기준으로 추정
2. 같은 등급의 카드는 동일한 확률로 습득한다고 가정함.
3. 일반, 고급, 희귀, 영웅, 전설의 확률은 다음의 연구결과를 사용한다
   (0.33, 0.25, 0.1, 0.01) 출처:http://qing.one/1133
"""
function simulation(gacha_grade; n = 1000)

    trial = Dict{String, Int}()
    compose = Dict{String, Vector{Int}}()
    @showprogress for i in 1:n
        a, b = montecarlo_simulation(gacha_grade)
        merge!(+, trial, a)
        merge!(+, compose, b)
    end

    # 결과 종합
    average_trial = Dict(zip(keys(trial), collect(values(trial)) ./ n))
    average_compose = Dict(zip(keys(compose), collect(values(compose)) ./ n))

    df = DataFrame([String, Float64, Float64, Float64, Float64, Float64],
        [:목표, :합성횟수_일반, :합성횟수_고급, :합성횟수_희귀, :합성횟수_영웅, :가챠횟수],
        7)

    for i in 1:nrow(df)
        target = ("첫고급", "모든고급", "첫희귀", "모든희귀", "첫영웅", "모든영웅", "첫전설")[i]
        df[i, :목표] = target
        df[i, :가챠횟수] = average_trial[target]

        df[i, :합성횟수_일반] = average_compose[target][1]
        df[i, :합성횟수_고급] = average_compose[target][2]
        df[i, :합성횟수_희귀] = average_compose[target][3]
        df[i, :합성횟수_영웅] = average_compose[target][4]
    end

    file = "$PATH\\output\\simulation_$(gacha_grade).xlsx"
    if isfile(file)
        rm(file)
    end
    XLSX.writetable(file, collect(DataFrames.eachcol(df)), DataFrames.names(df))
    if Sys.iswindows()
        run(`powershell start \"$file\"`; wait=false)
    end
    return df
end