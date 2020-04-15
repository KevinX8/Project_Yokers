local options = {}

function options.SetDifficulty(difficulty)
    if difficulty == "debug" then
        EnemyLimit = 1000
        TimeDifficulty = 5000
        TimeIncrease = 1000
        EnemiesPerWave = 15
        MinTimeBetweenWaves = 1000
        MaxTimeBetweenWaves = 4000
        EggCapacity = 1000
        EgginInv = 1000
        MaxHearts = 5
        HeartDropChance = 1
        HeartLifeTime = 10
        MaxEggsPerEnemy = 5
        MinPlayerAccuracy = 0.2
        RedChance = 3
        BlueChance = 2
    end
    if difficulty == "normal" then
        EnemyLimit = 50
        TimeDifficulty = 120000
        TimeIncrease = 30000
        EnemiesPerWave = 5
        MinTimeBetweenWaves = 5000
        MaxTimeBetweenWaves = 10000
        EggCapacity = 30
        EgginInv = 20
        MaxHearts = 5
        HeartDropChance = 30
        HeartLifeTime = 5
        MaxEggsPerEnemy = 2
        MinPlayerAccuracy = 0.7
        RedChance = 9
        BlueChance = 19
    end
end

return options