const { onRequest } = require("firebase-functions/v2/https");
const { Telegraf } = require("telegraf");
const logger = require("firebase-functions/logger");

// Отримання значень зі змінних середовища
const BOT_TOKEN = require("firebase-functions").config().bot.token;
const WEB_APP_URL = require("firebase-functions").config().webapp.url;

// Ініціалізація бота
const bot = new Telegraf(BOT_TOKEN);

// Обробник команди /start
bot.start((ctx) => {
    ctx.reply("Ласкаво просимо до Hlibnytsia! 🌾", {
        reply_markup: {
            inline_keyboard: [
                [{ text: "Запустити гру 🌾", web_app: { url: WEB_APP_URL } }]
            ]
        }
    });
});

// Cloud Function для обробки Telegram Webhook
exports.telegramBot = onRequest(async (req, res) => {
    try {
        await bot.handleUpdate(req.body, res);
        logger.info("Update успішно оброблено");
    } catch (error) {
        logger.error("Помилка при обробці оновлення:", error);
        res.status(500).send("Помилка сервера");
    }
});
