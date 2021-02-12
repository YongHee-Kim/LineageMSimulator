const PATH = joinpath(dirname(@__FILE__), "..")
const GAMEDATA = Dict()

# 아이템 DB 로딩
function __init__()
    # 가챠 확률데이터 로딩
    GAMEDATA[:Gacha_MagicalDoll] = read_gacha("magicaldoll")
    GAMEDATA[:Gacha_TransformCard] = read_gacha("transformcard")
    
    GAMEDATA[:MagicalDoll] = read_gamedata("magicaldoll")
    GAMEDATA[:TransformCard] = read_gamedata("transformcard")
    
    global MAGICALDOLL_NAME = GAMEDATA[:MagicalDoll] |> df -> Dict(zip(df[!, :Id], df[!, "이름/옵션"]))
    global TRANSFORMCARD_NAME = GAMEDATA[:TransformCard] |> df -> Dict(zip(df[!, :Id], df[!, "이름/옵션"]))

    global MAGICALDOLL_GRADE = GAMEDATA[:MagicalDoll] |> df -> Dict(zip(df[!, :Id], df[!, "등급"]))
    global TRANSFORMCARD_GRADE = GAMEDATA[:TransformCard] |> df -> Dict(zip(df[!, :Id], df[!, "등급"]))

    # # UI용 변수
    global GRADENAME = ("일반", "고급", "희귀", "영웅", "전설")
    global TRANSFORMCARD_JOBNAME = ("근거리", "원거리", "마법", "이동", "창", "만능")
end