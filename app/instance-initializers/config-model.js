import Ember from 'ember';

const { uuid } = Ember;

export function initialize(instance) {
  const store = instance.container.lookup('store:main');
  const conf = instance.container.lookup('config:embedded');
  if (!conf) {
    return;
  }
  const pages = Ember.A(conf.get('pages'));
  pages.forEach((p, i)=> {
    p.id = 'page_' + uuid();
    p.position = i;
    store.push('page', p);
  });
}

export default {
  name: 'config-model',
  initialize: initialize
};
