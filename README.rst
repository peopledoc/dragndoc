DragNDoc
========

DragNDoc is JS application to help splitting and ordering document pages in sub documents.

.. image:: http://peopledoc.s3.amazonaws.com/dragndocdemo_v1.gif
    :alt: HTTPie compared to cURL
    :width: 800
    :align: center

Try it
------

Small PDF splitter application based on DragNDoc splitpdfapp.com http://splitpdfapp.com

Install
-------

Install npm on Ubuntu

    http://davidtsadler.com/archives/2012/05/06/installing-node-js-on-ubuntu/

Note: Change the version from the doc, Jan 2014 is 0.10.24

Then:

.. code-block:: bash

    $ npm install -g bower

    $ npm install -g brunch@1.7.20

Once you have Brunch, install this application's dependencies:

.. code-block:: bash

    $ npm install & bower install


Run
---

To build the app, run:

.. code-block:: bash

    $ brunch b

To watch for changes and re-compile:

.. code-block:: bash

    $ brunch w

Now open `index.html` in the public folder.

Production
----------

To compile css and js for production use:

.. code-block:: bash

    brunch build --production


Note that you can also get the latest compiled files under 'dist' folder.

Usage
-----

In your html template you need to import the following CSS and JS:

.. code-block:: html

    <script src="js/vendor.xxx.js" type="text/javascript"></script>
    <script src="js/app.xxx.js" type="text/javascript"></script>


Then initialize the DragNDoc app and pass it a map describing your pages:


.. code-block:: html

    <script type="text/javascript">
        // fetch pages from fixtures
        demo_pages = []
        for (var i=1;i<15;i++) {
          demo_pages.push({
            "name": "p. " + i,
            "small_src": "../demo/doc_previews/document_small_p" + i + ".png",
            "large_src": "../demo/doc_previews/document_large_p" + i + ".png",
          })
        }

        DragNDoc = require('application');

        DragNDoc.start({
           maxConcurrentLoadingPages: 2 # optional, defaults to false which means no limit
           pages: demo_pages,
           validationText: "Validate",
           onValidation: function(data) {
              alert(JSON.stringify(data));
           }
         })
    </script>


Options
-------

**pages**:

A list of metas describing the source document pages.

``name`` page name

``small_src`` thumb image source

``large_src`` large preview source (750x1000)


**validationText**:

The string you want to display on the "validate" button.

**onValidation**:

Callback fucntion called by DragNDrop to return the ``docs`` payload.
``docs`` is a list of list of pages:

.. code-block:: json

    [[{"id":5,"name":"p. 5"},{"id":6,"name":"p. 6"}],[{"id":13,"name":"p. 13"},{"id":14,"name":"p. 14"}]]


App Layout
----------

::

     +--------------------------------------------------------------------------------------+
     |                                          |                                           |
     |                                          |                                           |
     |     PagePickerCompositeView              |   ComposerCompositeView                   |
     |     A collection of Pages                |   A collection of Documents of pages      |
     |                                          |                                           |
     |    +-----+  +-----+  +-----+  +-----+    | +---------------------------------------+ |
     |    |     |  |     |  |     |  |     |    | | +-----+  +-----+  +-----+  +-----+    | |
     |    |     |  |     |  |     |  |     |    | | |     |  |     |  |     |  |     |    | |
     |    |     |  |     |  |     |  |     |    | | |     |  |     |  |     |  |     |    | |
     |    +-----+  +-----+  +-----+  +-----+    | | | +   |  |     |  |     |  |     |  + | |
     |                                          | | +-|---+  +-----+  +-----+  +-----+  | | |
     |    +-----+  +-----+                      | +---|---------------------------------|-+ |
     |    |     |  |     |                      |     |                                 |   |
     |    |     |  | +---------->  PageView     |     |                                 |   |
     |    |     |  |     |                      |     |                                 |   |
     |    +-----+  +-----+                      |     +------> PageView     DocView <---+   |
     |                                          |                                           |
     |                                          |   +------------+                          |
     |                                          |   |            |                          |
     |                                          |   |  Dropzone  |                          |
     |                                          |   |            |                          |
     |                                          |   +------------+                          |
     +--------------------------------------------------------------------------------------+


On the left side we have the `PagePicker` Marionette module handling pages selecction. It dislays a collection of pages and react to drag and keyboard events.

On the right side we have the `Composer` Marionette module.
It has a dropzone to receive pages selected and dragged from `PagePicker`.
Upon drop event in the 'DropZone' we create a new `Document` that we add to our `DocumentsCollection`.
Each Document itself is composed of a collection of pages.


Authors
-------

Gregory Tappero created DragNDoc with `Novapost <http://www.people-doc.com/>`_ R&D team.

Check also our `contributors <https://github.com/novapost/dragndoc/graphs/contributors>`_

Licence
-------

The MIT License (MIT)

Copyright (c) 2013 Tappero Gregory

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
