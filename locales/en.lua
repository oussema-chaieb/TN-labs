local Translations = {
    error = {
        missingstormram = "You don't have a Stormram on you..",
        notpolice = "You are not a police",
        incorrectpassword = "Incorrect Password !",
        missingkey = "You are missing the Keys",
        notauthorized = "You are not authorized",
        middleofprocess = "You need until the end of process",
        failure = "You failed",
        missingingrediants = "You are missing something",
        mixeurfull = "Mixer is full",
        putingrediantsfirst = "You need to put the ingrediants first",
        emptymixerfirst = "You need to empty the mixer first",
        machineisworking = "The Machine Is allready working",
        cancel = "you cancel !!",
        couldntpassmetharray = "you need to empty the meth and package them first",
        machinestillworking = "The Machine still working",
        nometharraytotake = "There is no meth array to take !!",
        noarrays = "No Arrays here",
        brokenfigureneeded = "You need %{count} broken figure",
        tookmetharrayfirst = "You need to took the meth array first",
    },
    success = {
        putingrediants = "You successfly put the ingrediants",
        Packagecoke = "You successfly Packaged coke",
        procurecoke = "You successfly Procured coke",
        Pouringcoke = "You successfly Poured coke",
        changecolthesback = "Time to leave !",
        changelabclothes = "you changed your clothes ! let's start working",
        machinestarted = "the machine has started",
        emptymixer = "you empty the mixer",
        takemetharray = "Good Job",
        addMethArray = "Good Job",
        hammerMethArray = "You are doing well so far !",
        packagereceive = "You got your meth !",
    },
    progressbar = {
        repairfigurine = "Argue with employee to repair figurine",
        changeclothes = "Changing clothes",
        setuptemp = "setup temperature",
        emptymixer = "empty the mixer",
        takemetharray = "Took Meth Array",
        addmetharray = "Add Meth Array",
    },
    label = {
        enterlab = "Enter Lab",
        leavelab = "Leave Lab",
        changepasscode = "Change passcode",
        repairfigurine = "repair figurine",
        puringcoke = "Puring coke",
        packagecoke = "Packaging coke",
        procurecoke = "Procuring coke",
        Pouringcoke = "Pouring Coke into the box",
        breakfigure = "Breaking figure"
    },
    menu = {
        enterlabheader = "Enter Lab",
        enterlabtext = "",
        raidlockheader = "Raid Lock",
        raidlocktext = "",
        exitHeader = "Exit",
        ingrediantsleftHeader = "Ingrediants left",
        metharrayleftheader = "Meth Arrays inside The Machine",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})