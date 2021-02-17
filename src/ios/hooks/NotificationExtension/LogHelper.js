class LogHelper {
  constructor(context) {
    this.context = context;
    this.events = this.context.requireCordovaModule('cordova-common').events;
  }
  debug(...args) {
    this.events.emit('verbose', ['[NetmeraPlugin]', ...args].join(' '));
  }
  warn(...args) {
    this.events.emit('warn', ['[NetmeraPlugin]', ...args].join(' '));
  }
  log(...args) {
    this.events.emit('log', ['[NetmeraPlugin]', ...args].join(' '));
  }
}

module.exports = LogHelper;