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

  once(eventName, callback) {
    const runCallbackAndUnregister = () => {
      callback();
      this.handlers[eventName] = this.handlers[eventName].filter(
        fn => fn !== runCallbackAndUnregister
      );
    };
    this.on(eventName, runCallbackAndUnregister);
  }

  emit(eventName, data, onCallbacksDone) {
    if (this.handlers[eventName]) {
      this.handlers[eventName].forEach(handler => handler(data));
    } else {
      console.warn(
        `EventHandler got event '${eventName}' but no handler was registered.`
      );
    }
    if (typeof onCallbacksDone === 'function') onCallbacksDone();
  }
}

export default EventHandler;
