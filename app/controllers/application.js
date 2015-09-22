import Ember from 'ember';

const { get } = Ember;

export default Ember.Controller.extend({
  isHelpVisible: false,
  unknownProperty(k) {
    const conf = this.container.lookup('config:embedded');
    if (conf) {
      return get(conf, k);
    }
  },
  actions: {
    toggleHelp() {
      this.toggleProperty('isHelpVisible');
    }
  }
});
