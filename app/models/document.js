import { Model } from 'ember-cli-simple-store/model';

export default Model.extend({
  addPage(page) {
    this.get('pages').pushObject(page);
    page.set('available', false);
  }
});
