to_state = data.get("to_state")
from_state = data.get("from_state")
entity_id = data.get("entity_id")

shannan = hass.states.get("device_tracker.beatrice")
jo = hass.states.get("person.jorg_thalheim")
calendar = hass.states.get("calendar.jo_shannan_jorg_thalheim")
not_together = hass.states.get("input_boolean.shannan_jo_not_together")

home = "home"
university = "University"
grunecker = "grunecker"


def get_message() -> str | None:
    logger.info(f"not_together: {not_together.state}")
    logger.info(f"to_state: {to_state}")
    logger.info(f"from_state: {from_state}")
    logger.info(f"entity_id: {entity_id}")
    logger.info(f"jo.entity_id: {jo.entity_id}")
    logger.info(f"shannan.entity_id: {shannan.entity_id}")
    logger.info(f"home: {home}")
    logger.info(f"uni: {university}")
    logger.info(f"entity_id == jo: {jo.entity_id == entity_id}")
    logger.info(f"entity_id == shannan: {shannan.entity_id == entity_id}")

    name = "Jörg" if entity_id == jo.entity_id else "Shannan"

    if to_state == home:
        return f"{name} is home"

    if from_state in (grunecker, "Grunecker"):
        return f"{name} left Grunecker"

    if to_state in (grunecker, "Grunecker"):
        return f"{name} is in Grunecker"

    if from_state == university:
        return f"{name} left uni"
    return None


def main() -> None:
    message = get_message()
    logger.info(f"message {message}")
    if message is None:
        return
    if not_together.state == "off":
        logger.info("skip notification, shannan and jo are together")
        return
    if entity_id == jo.entity_id:
        notify_service = "mobile_app_beatrice"
    else:
        notify_service = "pushover"

    logger.info(f"notify_service: {notify_service}")
    hass.services.call("notify", notify_service, {"message": message}, blocking=False)

    if jo.state == shannan.state:
        logger.info("shannan and jo are together now")
        hass.services.call(
            "input_boolean",
            "turn_off",
            {"entity_id": "input_boolean.shannan_jo_not_together"},
            blocking=False,
        )


main()
