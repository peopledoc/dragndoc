import Ember from 'ember';
import { Model } from 'ember-cli-simple-store/model';

export default Model.extend({
  pages: [],
  insert(page) {
    const pages = Ember.makeArray(page);
    this.get('pages').addObjects(pages);
    pages.invoke('set', 'available', false);
  },
  remove(page) {
    const pages = Ember.makeArray(page);
    this.get('pages').removeObjects(pages);
    pages.invoke('set', 'available', true);
  }
});
