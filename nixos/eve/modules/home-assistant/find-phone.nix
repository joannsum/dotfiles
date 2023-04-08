let
  notifyDevice = device_name: name: {
    speech.text = "Notified ${name}";
    action = {
      service = "icloud.play_sound";
      data_template.account = "slekwati@outlook.com";
      data_template.device_name = device_name;
    };
  };
in
{
  services.home-assistant.config = {
    conversation.intents = {
      FindIphone = [
        "find [Shannans] (phone|IPhone)"
      ];
      FindWatch = [
        "find [Shannans] (Watch|Apple Watch)"
      ];
      FindMacbook = [
        "find [Shannans] (laptop|Macbook)"
      ];
    };
    intent_script = {
      FindIphone = notifyDevice "beatrice" "Shannan's phone";
      FindWatch = notifyDevice "shannansapple_watch" "Shannan's watch";
      FindMacbook = notifyDevice "herbert" "Shannan's laptop";
    };
  };
}
