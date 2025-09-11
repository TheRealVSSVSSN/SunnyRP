/*-------------------------------------------------------------------------

    Wraith Radar System - v1.01
    Created by WolfKnight
    
-------------------------------------------------------------------------*/

let resourceName = "";
let radarEnabled = false;
const targets = {};

$(document).ready(() => {
    radarInit();

    const radarContainer = $("#policeradar");

    const fwdArrowFront = radarContainer.find(".fwdarrowfront");
    const fwdArrowBack = radarContainer.find(".fwdarrowback");
    const bwdArrowFront = radarContainer.find(".bwdarrowfront");
    const bwdArrowBack = radarContainer.find(".bwdarrowback");

    const fwdSame = radarContainer.find(".fwdsame");
    const fwdOpp = radarContainer.find(".fwdopp");
    const fwdXmit = radarContainer.find(".fwdxmit");

    const bwdSame = radarContainer.find(".bwdsame");
    const bwdOpp = radarContainer.find(".bwdopp");
    const bwdXmit = radarContainer.find(".bwdxmit");

    const radarRCContainer = $("#policeradarrc");

    window.addEventListener('message', (event) => {
        const item = event.data;

        if (item.resourcename) {
            resourceName = item.resourcename;
        }

        if (item.toggleradar) {
            radarEnabled = !radarEnabled;
            radarContainer.fadeToggle();
        }

        if (item.disableRadar) {
            radarEnabled = false;
            radarContainer.fadeOut();
        }

        if (item.hideradar) {
            radarContainer.fadeOut();
        } else if (item.hideradar === false) {
            radarContainer.fadeIn();
        }

        if (item.frontchange) {
            $(".frontant").empty().html(item.plate);
        }

        if (item.rearchange) {
            $(".rearant").empty().html(item.plate);
        }

        if (item.patrolspeed) {
            updateSpeed("patrolspeed", item.patrolspeed);
        }

        if (item.fwdspeed) {
            updateSpeed("fwdspeed", item.fwdspeed);
        }

        if (item.fwdfast) {
            updateSpeed("fwdfast", item.fwdfast);
        }

        if (item.lockfwdfast === true || item.lockfwdfast === false) {
            lockSpeed("fwdfast", item.lockfwdfast);
        }

        if (item.bwdspeed) {
            updateSpeed("bwdspeed", item.bwdspeed);
        }

        if (item.bwdfast) {
            updateSpeed("bwdfast", item.bwdfast);
        }

        if (item.lockbwdfast === true || item.lockbwdfast === false) {
            lockSpeed("bwdfast", item.lockbwdfast);
        }

        if (item.fwddir || item.fwddir === false) {
            updateArrowDir(fwdArrowFront, fwdArrowBack, item.fwddir);
        }

        if (item.bwddir || item.bwddir === false) {
            updateArrowDir(bwdArrowFront, bwdArrowBack, item.bwddir);
        }

        if (item.fwdxmit) {
            fwdXmit.addClass("active");
        } else if (item.fwdxmit === false) {
            fwdXmit.removeClass("active");
        }

        if (item.bwdxmit) {
            bwdXmit.addClass("active");
        } else if (item.bwdxmit === false) {
            bwdXmit.removeClass("active");
        }

        if (item.fwdmode) {
            modeSwitch(fwdSame, fwdOpp, item.fwdmode);
        }

        if (item.bwdmode) {
            modeSwitch(bwdSame, bwdOpp, item.bwdmode);
        }

        if (item.toggleradarrc) {
            radarRCContainer.toggle();
        }
    });
});

function radarInit() {
    $('.container').each((i, obj) => {
        $(obj).find('[data-target]').each((subi, subobj) => {
            targets[$(subobj).attr('data-target')] = $(subobj);
        });
    });

    $('#policeradarrc').find('button').each((i, obj) => {
        const ele = $(obj);
        if (ele.attr('data-action')) {
            ele.on('click', () => {
                const data = ele.data('action');
                sendData('RadarRC', data);
            });
        }
    });
}

function updateSpeed(attr, data) {
    targets[attr].find('.speednumber').each((i, obj) => {
        $(obj).html(data[i]);
    });
}

function lockSpeed(attr, state) {
    targets[attr].find('.speednumber').each((i, obj) => {
        if (state === true) {
            $(obj).addClass('locked');
        } else {
            $(obj).removeClass('locked');
        }
    });
}

function modeSwitch(sameEle, oppEle, state) {
    if (state === 'same') {
        sameEle.addClass('active');
        oppEle.removeClass('active');
    } else if (state === 'opp') {
        oppEle.addClass('active');
        sameEle.removeClass('active');
    } else if (state === 'none') {
        oppEle.removeClass('active');
        sameEle.removeClass('active');
    }
}

function updateArrowDir(fwdEle, bwdEle, state) {
    if (state === true) {
        fwdEle.addClass('active');
        bwdEle.removeClass('active');
    } else if (state === false) {
        bwdEle.addClass('active');
        fwdEle.removeClass('active');
    } else if (state === null) {
        fwdEle.removeClass('active');
        bwdEle.removeClass('active');
    }
}

function sendData(name, data) {
    fetch(`https://${resourceName}/${name}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    }).then(r => r.text()).then(datab => {
        if (datab && datab !== 'ok') {
            console.log(datab);
        }
    });
}
