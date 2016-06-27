module.exports = {
  title: "pimatic-mqtt device config schemas"
  PS4WakeupButtons:
    title: "PS4WakeupButtons config options"
    type: "object"
    extensions: ["xLink"]
    properties:
      buttons:
        description: "Buttons to display"
        type: "array"
        default: []
        format: "table"
        items:
          type: "object"
          properties:
            id:
              description: "Button id"
              type: "string"
            text:
              description: "Button text"
              type: "string"
            confirm:
              description: "Ask the user to confirm the button press"
              type: "boolean"
              default: false
}
