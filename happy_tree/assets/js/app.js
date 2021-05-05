// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";
import { Socket } from "phoenix";
import topbar from "topbar";
import { LiveSocket } from "phoenix_live_view";
import Webcam from "webcamjs";

let Hooks = {};

Hooks.Webcam = {
  capture(hook, selector) {
    Webcam.snap(function (dataUri, canvas, context) {
      hook.pushEventTo(selector, "snap", { dataUri: dataUri });
    });
  },
  mounted() {
    Webcam.set({
      width: 1280,
      height: 720,
      dest_width: 1280,
      dest_height: 720,
      image_format: "jpeg",
      jpeg_quality: 90,
      fps: 30,
    });
    Webcam.attach("#camera");

    Webcam.on("live", function () {
      var paragraph = document.getElementById("loading");
      paragraph.textContent = "";
    });

    const hook = this;
    const selector = "#" + this.el.id;

    document.getElementById("snap").addEventListener("click", () => {
      this.capture(hook, selector);
    });
  },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
