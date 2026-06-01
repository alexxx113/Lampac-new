from homeassistant.core import HomeAssistant
from homeassistant.helpers.discovery import load_platform

async def async_setup(hass: HomeAssistant, config):
    # Проверьте, установлен ли addon
    if not hass.data.get("lampac"):
        hass.data["lampac"] = True

        # Загрузите платформы, которые вы хотите использовать
        # Например:
        # load_platform(hass, "sensor", "lampac")
        # load_platform(hass, "switch", "lampac")

        # Запустите приложение Lampac
        # hass.async_create_task(hass.config_entries.async_setup(hass, config))

    return True
