Config = {}

Config.labs = {
    meth = {
        inside = vector4(997.01, -3200.65, -36.4, 90.4),
        outside = vector4(-64.6, -1567.82, 3.07, 56.95),
        Security = "keys",  -- password / keys / citizenid / job / gang
        job = {["cardealer"] = 0, ["mechanic"] = 1},
        gang = {["ballas"] = 1, ["vagos"] = 2},
        citizenid = { "acd15", "dqsdc12"},
        methkey = "methkey",
        cokekey = "cokekey",
        weedkey = "weedkey",
        labname = "methlab" -- never change that
    },
    coke = {
        inside = vector4(1088.68, -3187.87, -38.99, 275.5),
        outside = vector4(308.16, -1819.14, 3.07, 315.34),
        Security = "keys",  -- password / keys / citizenid / job / gang
        job = {["cardealer"] = 0, ["mechanic"] = 1},
        gang = {["ballas"] = 1, ["vagos"] = 2},
        citizenid = { "acd15", "dqsdc12"},
        methkey = "methkey",
        cokekey = "cokekey",
        weedkey = "weedkey",
        labname = "cokelab" -- never change that
    },
    weed = {
        inside = vector4(0, 0, 0, 90.4),
        outside = vector4(0, 0, 0, 114.95),
        Security = "keys",  -- password / keys / citizenid / job / gang
        job = {["cardealer"] = 0, ["mechanic"] = 1},
        gang = {["ballas"] = 1, ["vagos"] = 2},
        citizenid = { "acd15", "dqsdc12"},
        methkey = "methkey",
        cokekey = "cokekey",
        weedkey = "weedkey",
        labname = "weedlab" -- never change that
    }
}

Config.meth = {
    locations = {
        mixinglocation = {
            coords = vector3(1005.67, -3200.35, -38.52),
            options = {
                [1] = {
                    event = "tn-labs:cl:meth:mixing",
                    icon = 'fa-solid fa-bolt',
                    label = "Mixe",
                },
                [2] = {
                    event = "tn-labs:cl:meth:checkMixageIngrediants",
                    icon = 'fa-solid fa-bolt',
                    label = "check Ingrediants",
                }
            }
        },
        packagelocation = {
            coords = vector3(1014.44, -3194.94, -38.99),
            options = {
                [1] = {
                    event = "tn-labs:cl:meth:package",
                    icon = 'fa-solid fa-bolt',
                    label = "Package",
                }
            }
        },
        machinelocation = {
            coords = vector3(1007.95, -3201.31, -38.99),
            options = {
                [1] = {
                    event = "tn-labs:cl:meth:usemachine",
                    icon = 'fa-solid fa-bolt',
                    label = "Interact",
                },
                [2] = {
                    event = "tn-labs:cl:meth:machineprogression",
                    icon = 'fa-solid fa-bolt',
                    label = "check progression",
                },
                [3] = {
                    event = "tn-labs:cl:meth:passToMethArray",
                    icon = 'fa-solid fa-bolt',
                    label = "Empty the Mixer",
                },
            }
        },
        tookmetharray = {
            coords = vector3(1002.77, -3200.0, -38.99),
            options = {
                [1] = {
                    event = "tn-labs:cl:meth:tookMethArray",
                    icon = 'fa-solid fa-bolt',
                    label = "Took Meth Array",
                },
                [2] = {
                    event = "tn-labs:cl:meth:CheckArraysCount",
                    icon = 'fa-solid fa-bolt',
                    label = "check How Many Arrays",
                }
            }
        },
        hammermetharray = {
            coords = vector3(1012.08, -3194.95, -38.99),
            options = {
                [1] = {
                    event = "tn-labs:cl:meth:hammerMethArray",
                    icon = 'fa-solid fa-bolt',
                    label = "Hummer Meth Array",
                },
                [2] = {
                    event = "tn-labs:cl:meth:CheckArraysCounttwo",
                    icon = 'fa-solid fa-bolt',
                    label = "check How Many Arrays",
                },
                [3] = {
                    event = "tn-labs:cl:meth:addMethArray",
                    icon = 'fa-solid fa-bolt',
                    label = "Add Meth Arrays",
                }
            }
        },
        stachandclothess = {
            coords = vector3(997.5, -3199.89, -38.99),
            options = {
                [1] = {
                    event = "tn-labs:cl:meth:stash",
                    icon = 'fa-solid fa-bolt',
                    label = "Stash",
                },
                [2] = {
                    event = "tn-labs:cl:meth:clothes",
                    icon = 'fa-solid fa-bolt',
                    label = "Clothes",
                }
            }
        },
    },
    mixageIngredients = {
        ["sodium_hydroxide"] = 50,
        ["sulfuric_acid"] = 50
    },
    Outfits = { 
        male = {
            mask = { item = 61, texture = 0 },
            arms = { item = 203, texture = 0 },
            shirt = { item = 195, texture = 0 },
            jacket = { item = 178, texture = 0 },
            pants = { item = 11, texture = 0 },
            shoes = { item = 15, texture = 0 },
            hat = { item = -1, texture = 0 },
            glass = { item = 32, texture = 0 },
            accessories = { item = 0, texture = 0 },
        },
        female = {
            mask = { item = 0, texture = 0 },
            arms = { item = 4, texture = 0 },
            shirt = { item = 2, texture = 0 },
            jacket = { item = 229, texture = 0 },
            pants = { item = 3, texture = 15 },
            shoes = { item = 72, texture = 0 },
            hat = { item = 18, texture = 0 },
            glass = { item = 32, texture = 0 },
            accessories = { item = 0, texture = 0 },
        },
    },
    methArrayReward = 10,
    cokeTime = 300,
    mixingHackUi = "ps-ui" , -- ps-ui || boii_minigames
    mixingHackUiType = "circle" ,-- circle || varhack || thermite || maze || scramble
    -- config for ps-ui circle
    psuiNumberOfCircles = 2,
    psuiCircleMS = 20,
    -- config for ps-ui maze
    psuiMazeTime = 20,
    -- config for ps-ui varhack
    psuiNumberOfBlocks = 2,
    psuiVarhackTime = 3,
    -- themite
    psuiThermiteTime = 10,
    psuiGridsize = 5,
    psuiIncorrectBlocks = 3,
    -- scramble
    psuiScrumbleType = "numeric",
    psuiScrumbleTime = 30,
    psuiScrumbleMirrored = 0,

    -- anagram
    anagramStyle = 'default',
    anagramDifficulty = 10,
    anagramGuesses = 5,
    anagramTimer = 30000,

    -- button_mash
    button_mashStyle = 'default',
    button_mashDifficulty = 10,

    -- chip hack
    chip_hackStyle = 'default',
    chip_hackAmount = 2,
    chip_hackTimer = 20000,

    -- hangman
    hangmanStyle = 'default',
    hangmanDifficulty = 4,
    hangmanGuesses = 5,
    hangmanTimer = 30000,

    -- keydrop
    key_dropStyle = 'default',
    key_dropscore_limit = 5,
    key_dropmiss_limit = 5,
    key_dropfall_delay = 1000,
    key_dropnew_letter_delay = 2000,

    -- pincode
    pincodeStyle = 'default',
    pincodeDifficulty = 4,
    pincodeGuesses = 5,

    -- safecrack
    safe_crackStyle = 'default',
    safe_crackDifficulty = 5 ,

    -- wire_cut
    wire_cutStyle = 'default',
    wire_cutTimer =  60000,

}

Config.coke = {
    locations = {
        processleaf = {
            coords = vector3(1101.81, -3193.72, -38.99),
            options = {
                [1] = {
                    event = "tn-labs:cl:coke:leafproc",
                    icon = 'fa-solid fa-bolt',
                    label = "process leaf",
                },
            }
        },
        unpackaging = {
            coords = vector3(1087.18, -3195.22, -38.99),
            options = {
                [1] = {
                    event = "tn-labs:cl:coke:unpackage",
                    icon = 'fa-solid fa-bolt',
                    label = "Pouring Coke",
                },
            }
        },
        process = {
            coords = vector3(1095.06, -3196.54, -38.99),
            options = {
                [1] = {
                    event = "tn-labs:cl:coke:process",
                    icon = 'fa-solid fa-bolt',
                    label = "Process",
                }
            }
        },
        package = {
            coords = vector3(1101.32, -3198.79, -38.99),
            options = {
                [1] = {
                    event = "tn-labs:cl:coke:package",
                    icon = 'fa-solid fa-bolt',
                    label = "Package",
                }
            }
        },
        stachandclothes = {
            coords = vector3(1096.83, -3192.94, -38.99),
            options = {
                [1] = {
                    event = "tn-labs:cl:coke:stash",
                    icon = 'fa-solid fa-bolt',
                    label = "Stash",
                },
                [2] = {
                    event = "tn-labs:cl:coke:clothes",
                    icon = 'fa-solid fa-bolt',
                    label = "Clothes",
                }
            }
        },
    },  
    processleafIngrediants = {
        ["coca_leaf"] = 4,
        ["empty_green_boxes"] = 1,
    },
    processleafRewards = {
        ["coke_box"] = 1
    },

    unpackageIngrediants = {
        ["coke_box"] = 2
    },
    unpackageRewards = {
        ["coke_raw"] = 4
    },



    processIngrediants = {
        ["coke_raw"] = 6,
        ["baking_soda"] = 1
    },
    processRewards = {
        ["coke_pure"] = 1
    },


    packageIngrediants = {
        ["coke_figureempty"] = 1,
        ["coke_pure"] = 4,
    },
    packageRewards = {
        ["coke_figure"] = 1
    },
    Outfits = { 
        male = {
            mask = { item = 61, texture = 0 },
            arms = { item = 203, texture = 0 },
            shirt = { item = 195, texture = 0 },
            jacket = { item = 178, texture = 0 },
            pants = { item = 11, texture = 0 },
            shoes = { item = 15, texture = 0 },
            hat = { item = -1, texture = 0 },
            glass = { item = 32, texture = 0 },
            accessories = { item = 0, texture = 0 },
        },
        female = {
            mask = { item = 0, texture = 0 },
            arms = { item = 4, texture = 0 },
            shirt = { item = 2, texture = 0 },
            jacket = { item = 229, texture = 0 },
            pants = { item = 3, texture = 15 },
            shoes = { item = 72, texture = 0 },
            hat = { item = 18, texture = 0 },
            accessories = { item = 0, texture = 0 },
        },
    },
    Reward = 10,
}