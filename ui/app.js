const container = document.querySelector('.container');
let timePanel = document.getElementById("timePanel");
let timePanel2 = document.getElementById("timePanel2");
let timeDisplay = document.getElementById("timeDisplay");
let timeDisplay2 = document.getElementById("timeDisplay2");
let data;
window.addEventListener("message", function (event) {
    data = event.data.data;
    if (event.data.action === "Temp") {
        container.style.display = 'inline-block';
        $('input[type="range"]').on('input', function () {
            var ingredientId = $(this).attr('id');
            var temperature = $(this).val();
            $('#temperature' + ingredientId.substring(ingredientId.length - 1)).text(temperature + '°C');
        });
    } else if (event.data.action === "Time") {
        let timeInSeconds = event.data.data; // Assuming the time received is in seconds
        let totalTimeInitial = event.data.initialTime;
        updateTimePanel(timeInSeconds, totalTimeInitial);
    } else if (event.data.action === "Time2") {
        let timeInSeconds = event.data.data; // Assuming the time received is in seconds
        let totalTimeInitial = event.data.initialTime;
        updateTimePanel2(timeInSeconds, totalTimeInitial);
    }
});

window.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        container.style.display = 'none';
        timePanel.style.display = "none";
        timePanel2.style.display = "none";
        $.post("https://tn-labs/close");
    }
});

function startProcess() {
    var ingredient1 = parseInt($('#ingredient1').val());
    var ingredient2 = parseInt($('#ingredient2').val());
    var ingredient3 = parseInt($('#ingredient3').val());
    var ingredient4 = parseInt($('#ingredient4').val());
    container.style.display = 'none';
    if (data === "coke") {
        $.post("https://tn-labs/startCokeProcess", JSON.stringify({
            ingredient1: ingredient1,
            ingredient2: ingredient2,
            ingredient3: ingredient3,
            ingredient4: ingredient4,
        }));
    } else {
        $.post("https://tn-labs/startProcess", JSON.stringify({
            ingredient1: ingredient1,
            ingredient2: ingredient2,
            ingredient3: ingredient3,
            ingredient4: ingredient4,
        }));
    }
}

function updateTimePanel(totalTime, totalTimeInitial) {
    timePanel.style.display = "block";

    function updateDisplay() {
        let hours = Math.floor(totalTime / 3600);
        let minutes = Math.floor((totalTime % 3600) / 60);
        let seconds = totalTime % 60;

        let timeString;

        if (totalTime <= 0) {
            timeString = "00:00:00";
            totalTime = 0;
        } else {
            timeString = `${formatTime(hours)}:${formatTime(minutes)}:${formatTime(seconds)}`;
        }

        timeDisplay.innerText = timeString;

        // Calculate progress percentage
        let progressPercentage = Math.floor((totalTimeInitial - totalTime) / totalTimeInitial * 100);

        // Update the progress bar
        let progressBar = document.getElementById('progressBar');
        progressBar.innerHTML = progressPercentage + '%';
        progressBar.style.width = progressPercentage + '%';

        if (totalTime > 0) {
            totalTime--;
            setTimeout(updateDisplay, 1000);
        }
    }

    updateDisplay();
}

function updateTimePanel2(totalTime, totalTimeInitial) {
    timePanel2.style.display = "block";

    function updateDisplay2() {
        let hours = Math.floor(totalTime / 3600);
        let minutes = Math.floor((totalTime % 3600) / 60);
        let seconds = totalTime % 60;

        let timeString;

        if (totalTime <= 0) {
            timeString = "00:00:00";
            totalTime = 0;
        } else {
            timeString = `${formatTime(hours)}:${formatTime(minutes)}:${formatTime(seconds)}`;
        }

        timeDisplay2.innerText = timeString;

        // Calculate progress percentage
        let progressPercentage = Math.floor((totalTimeInitial - totalTime) / totalTimeInitial * 100);

        // Update the progress bar
        let progressBar = document.getElementById('progressBar2');
        progressBar.innerHTML = progressPercentage + '%';
        progressBar.style.width = progressPercentage + '%';

        if (totalTime > 0) {
            totalTime--;
            setTimeout(updateDisplay2, 1000);
        }
    }

    updateDisplay2();
}


function formatTime(value) {
    return value < 10 ? "0" + value : value;
}