# Intercept clicks in code and send it over HTTP

{request} = require './utils'


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
                if nowMs < lastTimeMs + 1000
                    return  # Already updating
                lastTimeMs = nowMs

                body = {
                    path: editor.getPath()
                    lineno: position.row
                    charno: position.column
                }
                console.log body
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
