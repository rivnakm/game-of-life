project('game_of_life', 'cpp')

incdir = include_directories('include')

argparse_dep = dependency('argparse')

subdir('src')

executable('game_of_life', sources, dependencies : argparse_dep, include_directories : incdir)
