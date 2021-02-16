# LineageM transform card cost simulator [[KR](README_KR.md)]
All data are from **Jul 13, 2017**

## Installation

``` julia
pkg>add "https://github.com/YongHee-Kim/LineageM_TransformCard"
```


## Use
``` julia
using LineageMSimulator

simulation(:상급; n = 10000)
```

## Simulation Result
### Data Source
1. Transform Card [DataBase](http://lineagem.inven.co.kr/dataninfo/polymorph/)
2. Gacha Probability [Official Data](https://lineagem.plaync.com/board/rules/list)
3. Probability of Upgrading at Compose [Research From Player](http://qing.one/1133)  
    - Compose Upgrade Probability: Normal(33%), High(25%), Rare(10%), **Legend has no data**  
    - Assumed same grade cards has equal chance of getting 


**Table1. High Grade Transform Gacha 100,000**

| Target     | ComposeCount_Normal | ComposeCount_High | ComposeCount_Rare | ComposeCount_Hero |  GachaCount | HardCurrencyCost | CashCost |
| ------ | ------: | ------: | ------: | ------: | -------: | --------: | ----------: |
| First High    |     0.0 |       - |       - |       - |      4.9 |       538 |     ₩13,456 |
| First Rare    |    10.9 |     2.3 |       - |       - |     75.7 |     8,253 |    ₩206,330 |
| All High Collected |    59.3 |    17.6 |     0.1 |       - |    286.0 |    31,195 |    ₩779,881 |
| First Hero    |   187.1 |    64.4 |     2.5 |       - |    824.1 |    89,899 |  ₩2,247,467 |
| All Rare Collected |   719.9 |   257.8 |    17.7 |     0.0 |  3,066.2 |   334,500 |  ₩8,362,497 |
| All Hero Collected | 5,288.5 | 1,917.1 |   186.9 |     8.0 | 22,284.8 | 2,431,066 | ₩60,776,648 |
