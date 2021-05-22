class EventHandler {
  constructor() {
    this.handlers = {};
  }

  on(eventName, callback) {
    if (!this.handlers[eventName]) {
      this.handlers[eventName] = [];
    }
    this.handlers[eventName].push(callback);
  }

  emit(eventName, data, onCallbacksDone) {
    if (this.handlers[eventName]) {
      this.handlers[eventName].forEach(handler => handler(data));

      if (typeof onCallbacksDone === 'function') {
        onCallbacksDone();
      }

      return;
    }
    console.warn(
      `EventHandler got event '${eventName}' but no handler was registered.`
    );
    onCallbacksDone();
  }
}

export default EventHandler;
