local Translations = {
    error = {
        missingstormram = "Vous n'avez pas de Stormram sur vous...",
        notpolice = "Vous n'êtes pas un policier",
        incorrectpassword = "Mot de passe incorrect !",
        missingkey = "Vous avez oublié les clés",
        notauthorized = "Vous n'êtes pas autorisé",
        middleofprocess = "Vous avez besoin d'aller jusqu'au bout du processus",
        failure = "Vous avez échoué",
        missingingrediants = "Il vous manque quelque chose",
        mixeurfull = "Le mixeur est plein",
        putingrediantsfirst = "Vous devez d'abord mettre les ingrédients",
        emptymixerfirst = "Vous devez d'abord vider le mixeur",
        machineisworking = "La machine est déjà en marche",
        cancel = "Vous avez annulé !!",
        couldntpassmetharray = "Vous devez d'abord vider le meth et les emballer",
        machinestillworking = "La machine fonctionne toujours",
        nometharraytotake = "Il n'y a pas d'array de meth à prendre !!",
        noarrays = "Pas d'arrays ici",
        brokenfigureneeded = "Vous avez besoin de %{count} figurines cassées",
        tookmetharrayfirst = "Vous devez d'abord prendre l'array de meth",
    },
    success = {
        putingrediants = "Vous avez réussi à mettre les ingrédients",
        Packagecoke = "Vous avez emballé la coke avec succès",
        procurecoke = "Vous avez procuré la coke avec succès",
        Pouringcoke = "Vous avez versé la coke avec succès",
        changecolthesback = "Il est temps de partir !",
        changelabclothes = "Vous avez changé de vêtements ! Commençons à travailler",
        machinestarted = "La machine a démarré",
        emptymixer = "Vous avez vidé le mixeur",
        takemetharray = "Bon travail",
        addMethArray = "Bon travail",
        hammerMethArray = "Vous vous en sortez bien jusqu'à présent !",
        packagereceive = "Vous avez reçu votre meth !",
    },
    progressbar = {
        repairfigurine = "Argumentez avec l'employé pour réparer la figurine",
        changeclothes = "Changement de vêtements",
        setuptemp = "Réglage de la température",
        emptymixer = "Vider le mixeur",
        takemetharray = "Prendre l'array de meth",
        addmetharray = "Ajouter l'array de meth",
    },
    label = {
        enterlab = "Entrer dans le laboratoire",
        leavelab = "Quitter le laboratoire",
        changepasscode = "Changer le code d'accès",
        repairfigurine = "Réparer la figurine",
        puringcoke = "Verser la coke",
        packagecoke = "Emballer la coke",
        procurecoke = "Obtenir de la coke",
        Pouringcoke = "Verser la coke dans la boîte",
        breakfigure = "Casser la figurine"
    },
    menu = {
        enterlabheader = "Entrer dans le laboratoire",
        enterlabtext = "",
        raidlockheader = "Verrouillage anti-raid",
        raidlocktext = "",
        exitHeader = "Sortie",
        ingrediantsleftHeader = "Ingrédients restants",
        metharrayleftheader = "Arrays de meth à l'intérieur de la machine",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})