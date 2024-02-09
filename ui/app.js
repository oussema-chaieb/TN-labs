const container = document.querySelector('.container');
let timePanel = document.getElementById("timePanel");
let timeDisplay = document.getElementById("timeDisplay");
window.addEventListener("message", function (event) {
    if (event.data.action === "Temp") {
        container.style.display = 'inline-block';
        $('input[type="range"]').on('input', function () {
            var ingredientId = $(this).attr('id');
            var temperature = $(this).val();
            $('#temperature' + ingredientId.substring(ingredientId.length - 1)).text(temperature + '°C');

            // Add logic to change color based on temperature value
            $(this).removeClass('green blue yellow red'); // Remove existing classes
            if (temperature < 20) {
                $(this).addClass('green');
            } else if (temperature < 60) {
                $(this).addClass('blue');
            } else if (temperature < 78) {
                $(this).addClass('yellow');
            } else {
                $(this).addClass('red');
            }
        });
    } else if (event.data.action === "Time") {
        let timeInSeconds = event.data.data; // Assuming the time received is in seconds
        let totalTimeInitial = event.data.initialTime;
        updateTimePanel(timeInSeconds, totalTimeInitial);
    }
});

window.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        container.style.display = 'none';
        timePanel.style.display = "none";
        $.post("https://tn-labs/close");
    }
});

function startProcess() {
    // Get values from input fields
    var ingredient1 = parseInt($('#ingredient1').val());
    var ingredient2 = parseInt($('#ingredient2').val());
    var ingredient3 = parseInt($('#ingredient3').val());
    var ingredient4 = parseInt($('#ingredient4').val());
    container.style.display = 'none';
    $.post("https://tn-labs/startProcess", JSON.stringify({
        ingredient1: ingredient1,
        ingredient2: ingredient2,
        ingredient3: ingredient3,
        ingredient4: ingredient4,
    }));
}

function updateTimePanel(totalTime, totalTimeInitial) {
    timePanel.style.display = "block";

    function updateDisplay() {
        let hours = Math.floor(totalTime / 3600);
        let minutes = Math.floor((totalTime % 3600) / 60);
        let seconds = totalTime % 60;

        let timeString = `${formatTime(hours)}:${formatTime(minutes)}:${formatTime(seconds)}`;
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
        } else {
            totalTime = 0;
        }
    }

    updateDisplay();
}

function formatTime(value) {
    return value < 10 ? "0" + value : value;
}