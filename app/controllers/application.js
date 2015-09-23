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
    this.set('selectedItems', Ember.makeArray());
  }.on('init'),
  sortedDocuments: Ember.computed('documents.[]', {
    get() {
      return this.get('documents').toArray().reverse();
    }
  }).readOnly(),
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
    let callback;
    const config = this.container.lookup('config:embedded');
    if (config) {
      callback = get(config, 'onValidation');
    }
    callback = callback || console.log.bind(console);
    callback(results);
  },
  actions: {
    toggleHelp() {
      this.toggleProperty('isHelpVisible');
    },
    handleClick(page, event) {
      let action = 'toggleZoom';
      if (event.ctrlKey || event.metaKey) { //Don't forget the Mac users
        action = 'toggleSelectedPage';
      }
      this.send(action, page, event);
    },
    selectPage(page) {
      if (!page.get('available')) {
        return;
      }
      const selected = this.get('selectedItems');
      selected.addObject(page);
    },
    toggleSelectedPage(page) {
      if (!page.get('available')) {
        return;
      }
      const selected = this.get('selectedItems');
      if (selected.contains(page)) {
        selected.removeObject(page);
      } else {
        this.send('selectPage', page);
      }
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
      this.send('addPage', doc, page);
    },
    addPage(doc, page) {
      this.send('selectPage', page);
      this.send('flushSelection', doc);
    },
    flushSelection(doc) {
      const selected = this.get('selectedItems');
      doc.insert(selected);
      selected.clear();
    },
    serialize() {
      this.serialize(this.get('sortedDocuments'));
    },
    removePage(page, document) {
      document.remove(page);
      if (document.get('pages.length') === 0) {
        this.store.remove('document', document.get('id'));
      }
    }
  }
});
