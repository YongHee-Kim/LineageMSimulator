const PATH = joinpath(dirname(@__FILE__), "..")
const GAMEDATA = Dict()

# 아이템 DB 로딩
GAMEDATA[:MagicalDoll] = read_gamedata("magicaldoll")
GAMEDATA[:TransformCard] = read_gamedata("transformcard")
MAGICALDOLL_NAME = GAMEDATA[:MagicalDoll] |> df -> Dict(zip(df[:id], df[:name]))
TRANSFORMCARD_NAME = GAMEDATA[:TransformCard] |> df -> Dict(zip(df[:id], df[:name]))

MAGICALDOLL_GRADE = GAMEDATA[:MagicalDoll] |> df -> Dict(zip(df[:id], df[:grade]))
TRANSFORMCARD_GRADE = GAMEDATA[:TransformCard] |> df -> Dict(zip(df[:id], df[:grade]))


# 가챠 확률데이터 로딩
GAMEDATA[:Gacha_MagicalDoll] = read_gacha("magicaldoll")
GAMEDATA[:Gacha_TransformCard] = read_gacha("transformcard")
GAMEDATA[:Compose_TransformCard] = map(grade -> @where(GAMEDATA[:TransformCard],
                                        :grade .== grade)[:id], 1:5)

# UI용 변수
GRADENAME = ("일반", "고급", "희귀", "영웅", "전설")
TRANSFORMCARD_JOBNAME = ("근거리", "원거리", "마법", "이동", "창", "만능")
