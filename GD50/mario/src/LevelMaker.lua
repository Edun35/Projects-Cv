--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height, levelcounter)
    local tiles = {}
    local entities = {}
    local objects = {}

    local keyspawned = false
    -- vars to make sure only 1 of each is spawned
    local lockspawned = false
    Keyobtained = false
    Flagspawned = false
    levelcounter = levelcounter
   
    local tileID = TILE_ID_GROUND

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY

        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2

                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,

                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end

                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil

            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            --chance to spawn key
            if math.random(width - 10 - x) == 1 and not keyspawned then
                local key = GameObject {
                    texture = 'keys_and_locks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE - 4,
                    width = 16,
                    height = 16,
                    frame = math.random(#KEYS),
                    collidable = true,
                    consumable = true,
                    solid = false,

                    -- key has its own function to add to the player's score
                    onConsume = function(player, object)
                        gSounds['pickup']:play()
                        Keyobtained = true
                        lock.consumable = true
                        lock.solid = false                    
                    end
                }

                keyspawned = true

                table.insert(objects, key)
            --chance to spawn lock
            elseif math.random(width - 10 - x) == 1 and keyspawned and not lockspawned then
                lockspawned = true
                
                lock = GameObject {
                    texture = 'keys_and_locks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,

                    -- make it a random variant
                    frame = math.random(#KEYS) + 4,
                    collidable = true,
                    consumable = false,
                    solid = true,
                    onConsume = function (player, object)
                        
                        -- spawn a gem if we haven't already hit the block
                        if Keyobtained then
                            gSounds['powerup-reveal']:play()
                            Flagspawned = true
                            table.remove(objects, GameObject.lock)

                            --check safe spawn
                            local xpos = width - 1
                            local ground = false
                            local nopillar = false
                        
                            while not ground and not nopillar do
                                if tiles[7][xpos].id == TILE_ID_EMPTY then
                                    ground = false
                                    nopillar = false
                                    xpos = xpos - 1
                                else
                                    ground = true
                                    if tiles[5][xpos].id == TILE_ID_GROUND then
                                        nopillar = false
                                        ground = false
                                        xpos = xpos - 1
                                    else
                                        nopillar = true
                                    end
                                end
  
                            end

                            
                            -- maintain reference so we can set it to nil
                            local pole = GameObject {
                                texture = 'poles',
                                x = (xpos - 1) * TILE_SIZE,
                                y = (height - 7) * TILE_SIZE,
                                width = 16,
                                height = 48,
                                frame = math.random(#POLES),
                                collidable = true,
                                consumable = true,
                                solid = false,
                                -- gem has its own function to add to the player's score
                                onConsume = function(player, object)
                                    gSounds['pickup']:play()
                                    gStateMachine:change('play', {
                                        levelcounter = levelcounter + 1,
                                        score = player.score
                                    })
                                end
                            }

                            local flag = GameObject {
                                texture = 'flags',
                                x = ((xpos - 1) * TILE_SIZE) + 9,
                                y = ((height - 7) * TILE_SIZE) + 5,
                                width = 16,
                                height = 16,
                                frame = FLAGS[math.random(4)],
                                animation = Animation {
                                    frames = {0,1},
                                    interval = 0.5
                                },
                                collidable = true,
                                consumable = true,
                                solid = false,
                                
                                -- gem has its own function to add to the player's score
                                onConsume = function(player, object)
                                    gSounds['pickup']:play()
                                    gStateMachine:change('play', {
                                        levelcounter = levelcounter + 1,
                                        score = player.score
                                    })
                                end
                            }
                            table.insert(objects, pole)
                            table.insert(objects, flag)
                        end
                    end,
                    
                    -- collision function takes itself
                     onCollide = function(obj)
                        if not Keyobtained then
                            gSounds['empty-block']:play()
                        end
                    end

                }

            table.insert(objects, lock)

            -- chance to spawn a block
            elseif math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }

                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)
end

function LevelMaker.checkspawn(map)
    local x = 1
    local ground = false

    while not ground do
        if map.tiles[7][x].id == TILE_ID_EMPTY then
            x = x + 1
        else
            ground = true
        end
    end
    return x
end