(function() {
    'use strict';
    // code here
    var speed = 1;

    document.addEventListener('keypress', (event) => {
        const keyName = event.key;
        if (keyName === 'z'){
            if (speed === 1){
                speed = 3;
            }
            else{
                speed = 1;
            }
        }
    });

    document.addEventListener('keydown', (event) => {
        const keyName = event.key;
        const player = document.getElementById('player');
        if (! player.style.left){
            player.style.left = 0;
        }
        const move = 5 * speed;
        const current_position = parseInt(player.style.left);
        if (keyName === 'ArrowLeft'){
            player.style.left = current_position - move + 'px';
        }
        if (keyName === 'ArrowRight'){
            player.style.left = current_position + move + 'px';
        }
        if (keyName === 'x'){
            const image = document.createElement('img');
            image.type = "image";
            image.src = "imgs/fireball.png";
            image.id = "fireball";
            image.style.height = 90 + 'px';
            image.style.width = 90 + 'px';
            image.style.position = "absolute";
            image.style.left = current_position + 60 + 'px';
            image.style.bottom = 118 + 'px';
            document.body.appendChild(image);
        }
    });

    setInterval(function () {
        const fireball = document.getElementById('fireball');
        const current_fireball = parseInt(fireball.style.left);
        fireball.style.left = current_fireball + 10 + "px";
    }, 50);
}());
