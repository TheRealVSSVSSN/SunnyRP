/*
    Type: FiveM Server Script
    Name: pPassword
    Use: Presents an adaptive card for server password verification.
    Created: 09/10/2025
    By: VSSVSSN
*/

const defaultConfig = {
    serverPassword: "12345",
    serverName: "GTALife",
    serverWebsite: "https://www.gtaliferp.fr",
    serverLogo: "https://gtaliferp.fr/img/logo+hi.png",
    cardTitle: "Access denied. Please enter server's password",
    enterText: "Enter",
    passwordPlaceholder: "Password",
    wrongPasswordMessage: "This is not the right password."
};

/**
 * Type: Function
 * Name: loadUserConfig
 * Use: Loads JSON configuration or returns null on failure.
 * Created: 09/10/2025
 * By: VSSVSSN
 */
function loadUserConfig() {
    try {
        const raw = LoadResourceFile(GetCurrentResourceName(), "config.json");
        if (raw) {
            return JSON.parse(raw);
        }
    } catch (e) {
        console.log("[pPassword] Configuration file not loaded.");
    }
    return null;
}

const userConfig = loadUserConfig() || defaultConfig;

// Generated using https://adaptivecards.io/designer/
const adaptiveCardTemplate = {
    type: "AdaptiveCard",
    body: [
        {
            type: "TextBlock",
            size: "Medium",
            weight: "Bolder",
            text: userConfig.cardTitle
        },
        {
            type: "ColumnSet",
            columns: [
                {
                    type: "Column",
                    items: [
                        {
                            type: "Image",
                            url: userConfig.serverLogo,
                            size: "Small"
                        }
                    ],
                    width: "auto"
                },
                {
                    type: "Column",
                    items: [
                        {
                            type: "TextBlock",
                            weight: "Bolder",
                            text: userConfig.serverName,
                            wrap: true
                        },
                        {
                            type: "TextBlock",
                            spacing: "None",
                            text: userConfig.serverWebsite,
                            isSubtle: true,
                            wrap: true
                        }
                    ],
                    width: "stretch"
                }
            ]
        },
        {
            type: "Input.Text",
            placeholder: userConfig.passwordPlaceholder,
            inlineAction: {
                type: "Action.Submit",
                id: "",
                title: userConfig.enterText
            },
            id: "password"
        }
    ],
    version: "1.0",
    $schema: "http://adaptivecards.io/schemas/adaptive-card.json"
};

/**
 * Type: Function
 * Name: delay
 * Use: Promisified timeout helper.
 * Created: 09/10/2025
 * By: VSSVSSN
 */
const delay = (ms) => new Promise((res) => setTimeout(res, ms));

/**
 * Type: Function
 * Name: showCard
 * Use: Displays the adaptive card and validates the password.
 * Created: 09/10/2025
 * By: VSSVSSN
 */
async function showCard(deferrals) {
    deferrals.presentCard(JSON.stringify(adaptiveCardTemplate), async (data) => {
        if (data.password && data.password === userConfig.serverPassword) {
            deferrals.done();
        } else {
            deferrals.update(userConfig.wrongPasswordMessage);
            await delay(2000);
            showCard(deferrals);
        }
    });
}

on('playerConnecting', (name, setKickReason, deferrals) => {
    deferrals.defer();
    showCard(deferrals);
});

