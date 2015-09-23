import Ember from 'ember';
import Document from '../../../models/document';
import { module, test } from 'qunit';

module('Unit | Models | document');

test('it marks a page as unavailable when added to it', function (assert) {
  const doc = Document.create();
  const page = Ember.Object.create();
  doc.addPage(page);
  assert.equal(page.get('available'), false);
});

test('it marks a page as available when removed from it', function (assert) {
  const doc = Document.create();
  const page = Ember.Object.create();
  doc.addPage(page);
  doc.removePage(page);
  assert.equal(page.get('available'), true);
});
