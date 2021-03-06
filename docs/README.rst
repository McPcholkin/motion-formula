.. _readme:

motion-formula
================

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/TEMPLATE-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/TEMPLATE-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

A SaltStack formula to install and configure motion.

.. contents:: **Table of Contents**

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please pay attention to the ``pillar.example`` file and/or `Special notes`_ section.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

Special notes
-------------

.. <REMOVEME

Using this template
^^^^^^^^^^^^^^^^^^^

The easiest way to use this template formula as a base for a new formula is to use GitHub's **Use this template** button to create a new repository. For consistency with the rest of the formula ecosystem, name your formula repository following the pattern ``<formula theme>-formula``, where ``<formula theme>`` consists of lower-case alphabetic characters and numbers.

In the rest of this example we'll use ``example`` as the ``<formula theme>``.

Follow these steps to complete the conversion from ``template-formula`` to ``example-formula``. ::

  $ git clone git@github.com:YOUR-USERNAME/example-formula.git
  $ cd example-formula/
  $ bin/convert-formula.sh example
  $ git push --force

Alternatively, it's possible to clone ``template-formula`` into a new repository and perform the conversion there. For example::

  $ git clone https://github.com/saltstack-formulas/template-formula example-formula
  $ cd example-formula/
  $ bin/convert-formula.sh example

To take advantage of `semantic-release <https://github.com/semantic-release/semantic-release>`_ for automated changelog generation and release tagging, you will need a GitHub `Personal Access Token <https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line>`_ with at least the **public_repo** scope.

In the Travis repository settings for your new repository, create an `environment variable <https://docs.travis-ci.com/user/environment-variables/#defining-variables-in-repository-settings>`_ named ``GH_TOKEN`` with the personal access token as value, restricted to the ``master`` branch for security.

.. REMOVEME>

Available states
----------------

.. contents::
   :local:

``motion``
^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This installs the motion package,
manages the motion configuration file, manage exposition fix, manage mask files, manage telegram script and then
starts the associated motion service.

``motion.package``
^^^^^^^^^^^^^^^^^^^^

This state will install the motion package only.

``motion.config``
^^^^^^^^^^^^^^^^^^^

This state will configure the motion service and has a dependency on ``motion.install``
via include list.

``motion.service``
^^^^^^^^^^^^^^^^^^^^

This state will start the motion service and has a dependency on ``motion.config``
via include list.

``motion.clean``
^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

this state will undo everything performed in the ``motion`` meta-state in reverse order, i.e.
stops the service,
removes the configuration file, cleanup cron, delete mask files, delete telegram script, restore stock config and
then uninstalls the package.

``motion.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will stop the motion service and disable it at boot time.

``motion.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the configuration of the motion service and has a
dependency on ``motion.service.clean`` via include list.

``motion.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^

``motion.mask``
^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This state create mask file from pillar.

``motion.mask.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state create mask file from pillar.

``motion.mask.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the mask file.


``motion.exposition``
^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This state create cron jobs to change camera gamma for day and night.

``motion.exposition.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will configure the motion exposition and has a
dependency on ``motion.package`` via include list.

``motion.exposition.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the cron jobs of the motion exposition.

``motion.telegram``
^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This state create python script for send photos on camera action.
Also bot can ignore camera action based on known device list.

``motion.telegram.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state create python script for send photos on camera action.

``motion.telegram.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the telegram python script.


NOT DONE YET
============

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``TEMPLATE`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

