# 마법인형과 변신카드는 struct만 선언하고 사용은 안하고 있음
abstract type Item end

struct 마법인형 <: Item
    id::UInt8
    grade::Int8
    function 마법인형(id)
        new(id, itemgrade(마법인형, id))
    end
end
itemname(x::마법인형) = MAGICALDOLL_NAME[x.id]

struct 변신카드 <: Item
    id::UInt8
    grade::Int8
    job::Int8
    function 변신카드(id)
        job = transformcardjob(id)
        new(id, itemgrade(변신카드, id))
    end
end
itemname(x::변신카드) = TRANSFORMCARD_NAME[x.id]

function itemgrade(::Type{T}, id) where T <: Item
    if T == 마법인형
        MAGICALDOLL_GRADE[id]
    else
        TRANSFORMCARD_GRADE[id]
    end
end
transformcardjob(id) = @where(GAMEDATA[:TransformCard], :id .== id)[1, :job]


###############################################################################
##
##  Functions
##
###############################################################################
function addcard!(ac::계정, id)::Bool
    GRADENAME = (:일반, :고급, :희귀, :영웅, :전설)
    grade = itemgrade(변신카드, id)

    inven = getfield(ac.카드, GRADENAME[grade])
    if inven[id]
        # 1개 증가
        ac.잉여.카드[grade] +=1
        # 4개 이상일 경우에만 false를 리턴
        ac.잉여.카드[grade] < 4 ? true : false
    else
        inven[id] = true
    end
end
function drawcard(grade)
    poll = filter((k,v)->v == grade, TRANSFORMCARD_GRADE) |> keys
    sample(collect(poll))
end
