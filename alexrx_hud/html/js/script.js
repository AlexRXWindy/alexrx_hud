$(function(){

    anime({
        targets: '.box',
        translateX: 5,
        duration: function(s, i){
            if (i == 0){
                return 1600
            }else if(i == 1)
                return 1400
            else if(i == 2){
                return 1200
            }else if(i == 3){
                return 1000
            }else if(i == 4){
                return 800
            }else if(i == 5){
                return 600
            }
        },
        easing: 'easeOutQuad'
    });

    $('.wheelcolor').hide();

    let inChange = false;

    let left = true;

    let map = false;

    let colorSelected = 'rgba(223, 223, 223, 0.8)';

    $('#color-block').on('colorchange', function() {
        var color = $(this).wheelColorPicker('value');
        var alpha = $(this).wheelColorPicker('color').a;
        $('.color-preview-box').css('background-color', color);
        $('.color-preview-text').text(color);
        $('.color-preview-alpha').text(Math.round(alpha * 100) + '%');

        $.post('https://Region_hud/onChangeColor', JSON.stringify({
            color: colorSelected,
        }))

        colorSelected = color;
    });

    document.onkeyup = function(event){
        let key = event.key;

        if (key == 'Escape'){
            $('.wheelcolor').fadeOut(250);

            $.post('https://Region_hud/closeNui', JSON.stringify({
                color: colorSelected,
            }))
        };
    };

    window.addEventListener('message', function(event){
        
        let data = event.data

        if (data.action == 'send'){
            UpdateStats(data);
        }else if(data.action == 'changeColor'){
            $('.wheelcolor').fadeIn(250);
        }else if(data.action == 'onChangeColor'){
            colorSelected = data.color;
        };

    });

    UpdateStats = function(data){
        if (data.health == -100){
            data.health = 0;
        }

        if (data.map){
            $('.hud').fadeOut(500)
        }else{
            $('.hud').fadeIn(500)
        }

        // if (data.minimap){
        //     $('.hud').animate({left: '16vw', bottom: '1.75vw'}, 500)
        // }else{
        //     $('.hud').animate({left: '1vw', bottom: '1.75vw'}, 500)
        // }

        $('#hearth-inside').css('height', data.health + '%')
        $('#armour-inside').css('height', data.armour + '%')
        $('#hunger-inside').css('height', data.hunger + '%')
        $('#thirst-inside').css('height', data.thirst + '%')
        $('#stamine-inside').css('height', data.stamina + '%')
        $('#o2-inside').css('height', data.o2 + '%')

        if (data.whenYouNeed){

            if (data.health < 80){
                $('#hearth').fadeIn(500)
            }else{
                $('#hearth').fadeOut(500)
            }

            if (data.armour < 80 && data.armour > 0){
                $('#armour').fadeIn(500)
            }else{
                $('#armour').fadeOut(500)
            }

            if (data.hunger < 80){
                $('#hunger').fadeIn(500)
            }else{
                $('#hunger').fadeOut(500)
            }

            if (data.thirst < 80){
                $('#thirst').fadeIn(500)
            }else{
                $('#thirst').fadeOut(500)
            }

            if (data.stamina < 80){
                $('#stamine').fadeIn(500)
            }else{
                $('#stamine').fadeOut(500)
            }

            if (data.inWater){
                $('#o2').fadeIn(500)
            }else{
                $('#o2').fadeOut(500)
            }
        };

        if (data.minimap && left &! map &! inChange){
            left = false;
            inChange = true;
            anime({
                targets: '.box',
                translateX: (data.anchor.x+(data.anchor.width * screen.width)+20),
                translateY: 0,
                rotate: anime.stagger([360,360]),
                delay: function(el, i, l){
                    if (i ==  0){
                        return 1000
                    }else if (i == 1){
                        return 500
                    }else if (i == 2){
                        return 200
                    }else if (i == 3){
                        return 0
                    }else if (i == 4){
                        return 750
                    }else if (i == 5){
                        return 1500
                    }
                },
                duration: 1000,
                easing: 'easeOutElastic(.6, 1)'
            });

            setTimeout(function(){
                inChange = false;
            }, 1500)
        }else if(!data.minimap &! left &! map &! inChange){
            left = true;
            inChange = true;
            anime({
                targets: '.box',
                translateX: 0,
                translateY: 0,
                rotate: anime.stagger([0,0]),
                delay: function(el, i, l){
                    if (i ==  0){
                        return 1000
                    }else if (i == 1){
                        return 500
                    }else if (i == 2){
                        return 200
                    }else if (i == 3){
                        return 0
                    }else if (i == 4){
                        return 750
                    }else if (i == 5){
                        return 1500
                    }
                },
                duration: 1000,
                easing: 'easeOutElastic(.6, 1)'
            });
            setTimeout(function(){
                inChange = false;
            }, 1500)
        };
    };

    setInterval(function(){
        $('.box-inside').css({'background-color': colorSelected});
    }, 0)

});