import { Model } from 'ember-cli-simple-store/model';

export default Model.extend({
  pages: [],
  addPage(page) {
    this.get('pages').pushObject(page);
    page.set('available', false);
  },
  removePage(page) {
    this.get('pages').removeObject(page);
    page.set('available', true);
  }
});
