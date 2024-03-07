import consumer from "channels/consumer"

let resetFunc;
let timer = 0;

consumer.subscriptions.create("AppearanceChannel", {
  initialized() {},
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected");
    resetFunc = () => this.resetTimer(this.uninstall);
    this.install();
    window.addEventListener("turbo:load", () => this.resetTimer())
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("disconnected");
    this.uninstall();
  },
  rejected() {
    console.log("Rejected");
    this.uninstall();
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  },
  online(){
    console.log("online");
    this.perform("online");
  },
  away(){
    console.log("online");
    this.perform("online");
  },
  offline(){
    console.log("online");
    this.perform("online");
  },
  uninstall(){
    const shouldRun = document.getElementById("appearance_channel");
    if(!shouldRun){
      clearTimeout(timer);
      this.perform("offline");
    }
  },
  install(){
    console.log("Install");
    window.removeEventListener("load", resetFunc);
    window.removeEventListener("DOMContentLoaded", resetFunc);
    window.removeEventListener("click", resetFunc);
    window.removeEventListener("keydown", resetFunc);

    window.addEventListener("load", resetFunc);
    window.addEventListener("DOMContentLoaded", resetFunc);
    window.addEventListener("click", resetFunc);
    window.addEventListener("keydown", resetFunc);
    this.resetTimer();
  },
  resetTimer(){
    this.uninstall();
    const shouldRun = document.getElementById("appearance_channel");

    if(!!shouldRun){
      this.online();
      clearTimeout(timer);
      const timeInSecond = 5;
      const milliseconds = 1000;
      const timeInMilliseconds = timeInSecond * milliseconds;

      timer = setTimeout(this.away.bind(this), timeInMilliseconds)
    }
  }
});
