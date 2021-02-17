class LogHelper {
  constructor(context) {
    this.context = context;
    this.events = this.context.requireCordovaModule('cordova-common').events;
  }
  debug(...args) {
    this.events.emit('verbose', ['[NetmeraPlugin1]', ...args].join(' '));
  }
  warn(...args) {
    this.events.emit('warn', ['[NetmeraPlugin1]', ...args].join(' '));
  }
  log(...args) {
    this.events.emit('log', ['[NetmeraPlugin1]', ...args].join(' '));
  }
}

module.exports = LogHelper;