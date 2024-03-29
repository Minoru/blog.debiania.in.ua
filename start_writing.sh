#!/bin/sh

# Author: Alexander Batischev <eual.jp@gmail.com>
#
# This script fires up tmux with my writing setup

tmux has-session -t debiania || (
    # session doesn't exist, let's create one

    # first window is for editing

    vimoptions="set spell spelllang=ru_yo,en filetype=markdown nofoldenable tw=80"
    # Start vim:
    #   - go to the second line, i.e. the title
    #   - go to the Insert mode right away
    #   - set the options defined above
    #   - read initial file from the stdin
    vim="vim +2 -c 'startinsert!' -c \"$vimoptions\" -"
    # initial text. This is post metadata as used by Hakyll.
    text=`(
        echo    '---'
        echo    'title: '
        echo    'language: english russian'
        echo    'description: # No double quotes; end with a period'
        echo -n 'tags: ' && ./gather_tags
        echo    'enable-mathjax: true # delete if you do not need MathJax'
        echo    '---'
        echo    ''
        echo    '- What problem were I solving?'
        echo    '- How did I arrive at this particular solution?'
        echo    '(http://frantic.im/blogpost-contexts)'
    )`
    tmux new-session -d -s debiania "echo \"$text\" | $vim"
    tmux rename-window -t debiania:0 vim

    # none of the windows need activity monitoring, so I disable it
    tmux set-option -t debiania:watch -g monitor-activity off

    # second window is for version control
    tmux new-window -d -n git -t debiania

    # third window runs "debiania watch"
    tmux new-window -d -n watch -t debiania 'stack run -- watch'
)

tmux attach -t debiania
