import Ember from 'ember';

const { get } = Ember;

export default Ember.Controller.extend({
  isHelpVisible: false,
  pages: Ember.computed({
    get() {
      return this.get('store').find('page');
    }
  }),
  initDocuments: function () {
    this.set('documents', this.store.find('document'));
  }.on('init'),
  unknownProperty(k) {
    const conf = this.container.lookup('config:embedded');
    if (conf) {
      return get(conf, k);
    }
  },
  serialize(docs) {
    const results = docs.map((doc)=> {
      return doc.get('pages').map((page)=> {
        return {
          id: page.position, name: page.name
        };
      });
    }).toArray();
    console.log('RESULT', results);
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
    },
    createDocument(page) {
      const doc = this.store.push('document', { id: `document_${Ember.uuid()}`, pages: [] });
      doc.addPage(page);
    },
    serialize() {
      this.serialize(this.get('documents'));
    }
  }
});
