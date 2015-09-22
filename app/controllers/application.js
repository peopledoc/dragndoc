import Ember from 'ember';

const { get } = Ember;

export default Ember.Controller.extend({
  isHelpVisible: false,
  pages: Ember.computed({
    get() {
      return this.get('store').find('page');
    }
  }),
  unknownProperty(k) {
    const conf = this.container.lookup('config:embedded');
    if (conf) {
      return get(conf, k);
    }
  },
  actions: {
    toggleHelp() {
      this.toggleProperty('isHelpVisible');
    },
    toggleZoom(page) {
      if (page) {
        const img = new Image();
        img.src = page.get('large_src');
        img.addEventListener('load', ()=> {
          this.set('previewImage', page);
        });
      } else {
        this.set('previewImage', null);
      }
    }
  }
});
