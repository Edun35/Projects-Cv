BattleVictoryMenuState = Class{__includes = BaseState}

function BattleVictoryMenuState:init(battleState, params)
    self.battleState = battleState

    self.victoryMenu = Menu {
        x = VIRTUAL_WIDTH - 80,
        y = VIRTUAL_HEIGHT - 96,
        width = 80,
        height = 96,
        items = { 
            { text = 'HP   ' .. params.hp},
            { text = 'ATK  ' .. params.atk},
            { text = 'DEF  ' .. params.def },
            { text = 'SPD  ' .. params.spd}
        },
        userInput = false
    }
end

function BattleVictoryMenuState:update(dt)
    self.victoryMenu:update(dt)
end

function BattleVictoryMenuState:render()
    self.victoryMenu:render()
end