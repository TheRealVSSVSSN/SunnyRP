/*--------------------------------------------------------------------------

    ActionMenu
    Created by WolfKnight
    Additional help from lowheartrate, TheStonedTurtle, and Briglair.

--------------------------------------------------------------------------*/
function displayCash(cash) {
    return Number.isInteger(cash) ? '$' + cash : cash;
}

$(function() {
    // Adds all of the correct button actions
    init();

    // Gets the actionmenu div container
    var actionContainer = $("#ass");

    // Listens for NUI messages from Lua
    window.addEventListener('message', function(event) {
        var item = event.data;

        if (['vehicles','boats','aircrafts'].indexOf(item.receive) !== -1) {
            renderGarage(item.garage);
        }

        // Show the menu
        if (item.showmenu) {
            ResetMenu();
            actionContainer.show();
        }

        // Hide the menu
        if (item.hidemenu) {
            actionContainer.hide();
        }
    });
});

// Hides all div elements that contain a data-parent.
function ResetMenu() {
    $("div").each(function() {
        var element = $(this);
        if (element.attr("data-parent")) {
            element.hide();
        } else {
            element.show();
        }
    });
}

// Configures every button click to use its data-action, or data-sub to open a submenu.
function init() {
    // Loops through every button that has the class of "menuoption"
    $(".menuoption").each(function() {
        // If the button has a data-action, send the data to the lua side when pressed.
        if ($(this).attr("data-action")) {
            $(this).off('click').on('click', function() {
                var data = $(this).data("action");
                sendData("ButtonClick", data);
            });
        }

        // If the button has a data-sub, show the submenu and hide others when pressed.
        if ($(this).attr("data-sub")) {
            $(this).off('click').on('click', function() {
                var menu = $(this).data("sub");
                var element = $("#" + menu);
                element.show();
                $(this).parent().hide();
            });
        }
    });
}

// Send data to lua for processing.
function sendData(name, data) {
    $.post("http://fsn_cargarage/" + name, JSON.stringify(data), function(datab) {
        if (datab != "ok") {
            console.log(datab);
        }
    });
}

function renderGarage(garageData) {
    if (garageData == '[]') { return; }
    var grg = JSON.parse(garageData);
    $('.section').html('');
    document.querySelectorAll('[data-spawn="garage"]').forEach(function(item){ item.remove(); });
    $('.exit').remove();
    grg.forEach(function(val){
        var color, stat, price;
        switch (val.veh_status) {
            case 0: color='green'; stat='IN'; price=50; break;
            case 1: color='orange'; stat='OUT'; price='UNAVAILABLE'; break;
            case 2: color='red'; stat='IMPOUNDED'; price=2500; break;
            case 3: color='black'; stat='REPO/SEIZE'; price='UNAVAILABLE'; break;
        }
        $('.section').append('<button class="menuoption '+color+'" data-sub="'+val.veh_id+'">['+stat+'] '+val.veh_displayname+'</button>');
        $('#actionmenu').append('<div id="'+val.veh_id+'" data-spawn="garage" data-parent="mainmenu" style="display: none;"><button class="menuoption" data-action="spawn-'+val.veh_id+'">SPAWN (<b>'+displayCash(price)+'</b>)</button><button class="menuoption" data-action="sell-'+val.veh_id+'">SELL</button></div>');
    });
    $('#actionmenu').append('<button class="menuoption exit" data-action="exit">Exit</button>');
    init();
}
