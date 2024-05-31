function Game()
    return {
        state = {
            menu = true,
            running = false,
            gameover = false
        },

        changeGameState = function (self, state)
            self.state.menu = state == "menu"
            self.state.running = state == "running"
            self.state.gameover = state == "gameover"
        end

    }
end

return Game