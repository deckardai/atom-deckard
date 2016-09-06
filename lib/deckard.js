'use babel';

import DeckardView from './deckard-view';
import { CompositeDisposable } from 'atom';

export default {

  deckardView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.deckardView = new DeckardView(state.deckardViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.deckardView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'deckard:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.deckardView.destroy();
  },

  serialize() {
    return {
      deckardViewState: this.deckardView.serialize()
    };
  },

  toggle() {
    console.log('Deckard was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
