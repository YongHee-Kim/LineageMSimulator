struct 카드저장고
    일반::Dict{UInt8, Bool}
    고급::Dict{UInt8, Bool}
    희귀::Dict{UInt8, Bool}
    영웅::Dict{UInt8, Bool}
    전설::Dict{UInt8, Bool}
    합성시도횟수::Vector{Int}
    function 카드저장고()
        v = Dict[]
        for grade in 1:5
            ids =  @where(GAMEDATA[:TransformCard], :grade .== grade)[:id]
            push!(v, Dict(zip(ids, fill(false, length(ids)))))
        end
        tried = [0,0,0,0,0] #일반, 영웅, 고급, 희귀, 전설
        new(v[1], v[2], v[3], v[4], v[5], [0,0,0,0,0])
    end
end

mutable struct 잉여아이템
    카드::Vector{Int}
    function 잉여아이템()
        new(fill(0, 5))
    end
end

struct 계정
    카드::카드저장고
    잉여::잉여아이템
    계정() = new(카드저장고(), 잉여아이템())
end

###############################################################################
##
##  Functions
##
###############################################################################
# 중복되는 카드 찾아서 합성
function compose_card!(ac::계정)
    # 일반, 고급, 희귀, 영웅
    ## 출처 http://qing.one/1133
    PT = (0.33, 0.25, 0.1, 0.01)

    for i in 1:4
        if ac.잉여.카드[i] >= 4
            # 합성 카드 삭제
            ac.잉여.카드[i] -= 4
            ac.카드.합성시도횟수[i] += 1

            # 합성 결과 선택
            g = rand() < PT[i] ? i+1 : i
            cardid = drawcard(g)

            addcard!(ac, cardid)
        end
    end
end
