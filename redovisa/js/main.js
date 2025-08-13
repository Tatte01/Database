function createCounter() {
    let count = 0;

    return {
        Useless: function () {
            count++;
            return count;
        },
        reset: function() {
            count = 0;
            return count;
        }
    }
}

const counter = createCounter();

const disp = document.getElementById("display");
const button = document.getElementById("Butt");
const reset = document.getElementById("reset");


function handleButtonPress(action) {
    if (action === "Useless") {
        disp.innerHTML = counter.Useless();
    }
    else if (action === "reset"){
        disp.innerHTML = counter.reset();
    }
}

button.addEventListener("click", () => handleButtonPress("Useless"));
reset.addEventListener("click", () => handleButtonPress("reset"));

