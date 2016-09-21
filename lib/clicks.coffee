# Intercept clicks in code and send it over HTTP

{request} = require './utils'


maxLength = 1000
minPauseMs = 500

lastTimeMs = 0

module.exports = {
    init: ->
        atom.workspace.observeTextEditors (editor) ->
            editor.onDidChangeSelectionRange (ev) ->
                position = ev.newBufferRange.start

                end = ev.newBufferRange.end
                if position.row == end.row and position.column == end.column
                    return  # Not a selection

                nowMs = new Date().getTime()
                if nowMs < lastTimeMs + minPauseMs
                    return  # Already updating
                lastTimeMs = nowMs

                text = editor
                    .getTextInBufferRange(ev.newBufferRange)
                    .substr(0, maxLength)

                body = {
                    path: editor.getPath()
                    lineno: position.row
                    charno: position.column
                    end:
                        lineno: end.row
                        charno: end.column
                    text: text
                    editor: 'atom'
                }

                request {
                    url: 'http://localhost:3325/event'
                    method: 'post'
                    json: true
                    body: body
                }
                .catch (err) ->
                    console.error err
}

# Alternative: respond to all clicks
#editor.onDidChangeCursorPosition (ev) ->
#    position = ev.newBufferPosition
