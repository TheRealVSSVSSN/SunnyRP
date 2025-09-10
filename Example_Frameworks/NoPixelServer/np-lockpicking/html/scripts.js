let documentWidth = document.documentElement.clientWidth;
let documentHeight = document.documentElement.clientHeight;
let audioPlayer = null;
const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'np-lockpicking';

let minRot = -90,
    maxRot = 90,
    solveDeg = Math.random() * 180 - 90,
    solvePadding = 1,
    maxDistFromSolve = 25,
    pinRot = 0,
    cylRot = 0,
    lastMousePos = 0,
    mouseSmoothing = 2,
    keyRepeatRate = 25,
    cylRotSpeed = 3,
    pinDamage = 10,
    pinHealth = 100,
    pinDamageInterval = 150,
    numPins = 1,
    userPushingCyl = false,
    gameOver = false,
    gamePaused = false,
    pin,
    cyl,
    driver,
    cylRotationInterval,
    pinLastDamaged;

document.addEventListener('DOMContentLoaded', () => {
    pin = document.getElementById('pin');
    cyl = document.getElementById('cylinder');
    driver = document.getElementById('driver');

    document.body.addEventListener('mousemove', e => {
        if (lastMousePos && !gameOver && !gamePaused) {
            const pinRotChange = (e.clientX - lastMousePos) / mouseSmoothing;
            pinRot += pinRotChange / 2;
            pinRot = Util.clamp(pinRot, maxRot, minRot);
            pin.style.transform = `rotateZ(${pinRot}deg)`;
        }
        lastMousePos = e.clientX;
    });

    document.body.addEventListener('mouseleave', () => {
        lastMousePos = 0;
    });

    document.body.addEventListener('keydown', e => {
        if ((e.keyCode === 87 || e.keyCode === 65 || e.keyCode === 83 || e.keyCode === 68) && !userPushingCyl && !gameOver && !gamePaused) {
            pushCyl();
        }
        if (e.keyCode === 39 && !userPushingCyl && !gameOver && !gamePaused) {
            pinUpdate(1);
        }
        if (e.keyCode === 37 && !userPushingCyl && !gameOver && !gamePaused) {
            pinUpdate(2);
        }
    });

    document.body.addEventListener('keyup', e => {
        pinUpdate(0);

        if ((e.keyCode === 87 || e.keyCode === 65 || e.keyCode === 83 || e.keyCode === 68) && !gameOver) {
            unpushCyl();
        }

        if (e.keyCode === 27) {
            fetch(`https://${resource}/close`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: '{}'
            });
        }
    });

    document.body.addEventListener('touchstart', e => {
        console.log('touchStart', e);
    });
});

let updating = 0;
let pinUpdating = false;
function pinUpdate(set) {
    updating = set;
    if (set === 0 || pinUpdating) return;

    pinUpdating = true;
    pinRot = set === 1 ? pinRot + 1 : pinRot - 1;
    pin.style.transform = `rotateZ(${pinRot}deg)`;

    if (updating !== 0 && !userPushingCyl && !gameOver && !gamePaused) {
        setTimeout(() => {
            pinUpdating = false;
            pinUpdate(updating);
        }, 1);
    } else {
        pinUpdating = false;
    }
}

// CYL INTERACTIVITY EVENTS
function pushCyl() {
    let distFromSolve, cylRotationAllowance;
    clearInterval(cylRotationInterval);
    userPushingCyl = true;

    distFromSolve = Math.abs(pinRot - solveDeg) - solvePadding;
    distFromSolve = Util.clamp(distFromSolve, maxDistFromSolve, 0);

    cylRotationAllowance = Util.convertRanges(distFromSolve, 0, maxDistFromSolve, 1, 0.02);
    cylRotationAllowance = cylRotationAllowance * maxRot;

    cylRotationInterval = setInterval(() => {
        cylRot += cylRotSpeed;
        if (cylRot >= maxRot) {
            cylRot = maxRot;
            clearInterval(cylRotationInterval);
            unlock();
        } else if (cylRot >= cylRotationAllowance) {
            cylRot = cylRotationAllowance;
            damagePin();
        }

        cyl.style.transform = `rotateZ(${cylRot}deg)`;
        driver.style.transform = `rotateZ(${cylRot}deg)`;
    }, keyRepeatRate);
}

function unpushCyl() {
    userPushingCyl = false;
    clearInterval(cylRotationInterval);
    cylRotationInterval = setInterval(() => {
        cylRot -= cylRotSpeed;
        cylRot = Math.max(cylRot, 0);
        cyl.style.transform = `rotateZ(${cylRot}deg)`;
        driver.style.transform = `rotateZ(${cylRot}deg)`;
        if (cylRot <= 0) {
            cylRot = 0;
            clearInterval(cylRotationInterval);
        }
    }, keyRepeatRate);
}

// PIN AND SOLVE EVENTS
function damagePin() {
    if (!pinLastDamaged || Date.now() - pinLastDamaged > pinDamageInterval) {
        const tl = new TimelineLite();
        pinHealth -= pinDamage;
        pinLastDamaged = Date.now();

        tl.to(pin, (pinDamageInterval / 4) / 1000, {
            rotationZ: pinRot - 2
        });
        tl.to(pin, (pinDamageInterval / 4) / 1000, {
            rotationZ: pinRot
        });
        if (pinHealth <= 0) {
            breakPin();
        }
    }
}

function breakPin() {
    playSound('pinbreak', 0.3);
    let tl, pinTop, pinBott;
    gamePaused = true;
    clearInterval(cylRotationInterval);
    numPins--;
    const span = document.querySelector('span');
    if (span) span.textContent = numPins;
    pinTop = pin.querySelector('.top');
    pinBott = pin.querySelector('.bott');
    tl = new TimelineLite();
    tl.to(pinTop, 0.7, {
        rotationZ: -400,
        x: -200,
        y: -100,
        opacity: 0
    });
    tl.to(pinBott, 0.7, {
        rotationZ: 400,
        x: 200,
        y: 100,
        opacity: 0,
        onComplete: () => {
            if (numPins > 0) {
                gamePaused = false;
                reset();
            } else {
                outOfPins();
            }
        }
    }, 0);
    tl.play();
}

function reset() {
    cylRot = 0;
    pinHealth = 100;
    pinRot = 0;
    pin.style.transform = `rotateZ(${pinRot}deg)`;
    cyl.style.transform = `rotateZ(${cylRot}deg)`;
    driver.style.transform = `rotateZ(${cylRot}deg)`;
    TweenLite.to(pin.querySelector('.top'), 0, {
        rotationZ: 0,
        x: 0,
        y: 0,
        opacity: 1
    });
    TweenLite.to(pin.querySelector('.bott'), 0, {
        rotationZ: 0,
        x: 0,
        y: 0,
        opacity: 1
    });
}

function playSound(file, volume) {
    if (audioPlayer != null) {
        audioPlayer.pause();
    }
    audioPlayer = new Audio(`./sounds/${file}.ogg`);
    audioPlayer.volume = volume;
    audioPlayer.play();
}

function outOfPins() {
    fetch(`https://${resource}/failure`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: '{}'
    });
    gameOver = true;
    const lose = document.getElementById('lose');
    const modal = document.getElementById('modal');
    if (lose) lose.style.display = 'inline-block';
    if (modal) modal.style.display = 'block';
}

function unlock() {
    fetch(`https://${resource}/complete`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: '{}'
    });
    playSound('lockUnlocked', 0.6);
    gameOver = true;
    const win = document.getElementById('win');
    const modal = document.getElementById('modal');
    if (win) win.style.display = 'inline-block';
    if (modal) modal.style.display = 'block';
}

// UTIL
const Util = {};
Util.clamp = function (val, max, min) {
    return Math.min(Math.max(val, min), max);
};
Util.convertRanges = function (OldValue, OldMin, OldMax, NewMin, NewMax) {
    return (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin;
};

let gameObject = null;

function openContainer() {
    document.getElementById('wrap').style.display = 'block';
    document.body.style.backgroundColor = 'rgba(190,190,190,0.2)';
}

function closeContainer() {
    document.getElementById('wrap').style.display = 'none';
    document.body.style.backgroundColor = 'rgba(190,190,190,0.0)';
}

// Listen for NUI Events
window.addEventListener('message', event => {
    const item = event.data;

    if (item.openPhone === true) {
        openContainer();
    }

    if (item.openSection === 'playgame') {
        solveDeg = Math.random() * 180 - 90;
        solvePadding = item.padding;
        maxDistFromSolve = item.solveDist;
        pinDamage = item.damage;
        pinHealth = item.health;

        minRot = -90;
        maxRot = 90;
        pinRot = 0;
        cylRot = 0;
        lastMousePos = 0;
        mouseSmoothing = 2;
        keyRepeatRate = 25;
        cylRotSpeed = 3;
        pinDamageInterval = 150;
        numPins = 1;
        userPushingCyl = false;
        gameOver = false;
        gamePaused = false;
        pin = document.getElementById('pin');
        cyl = document.getElementById('cylinder');
        driver = document.getElementById('driver');
        cylRotationInterval = null;
        pinLastDamaged = null;

        reset();
    }

    if (item.openPhone === false) {
        closeContainer();
    }
});

