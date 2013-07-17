#!/usr/bin/env python
import os

def next(qfilename, args):
    """(default) Return the top item in the queue"""
    return open(qfilename, 'r').readline()

def all(qfilename, args):
    """Show all the items in the queue"""
    return open(qfilename, 'r').read()

def append(qfilename, args):
    """Add one or more lines to the end of the queue"""
    qfile = open(qfilename, 'r')
    current_lines = qfile.readlines()
    qfile.close()

    lines = current_lines + [line + '\n' for line in args]
    qfile_tmp = open(qfilename + '.tmp', 'w')
    qfile_tmp.writelines(lines)
    qfile_tmp.flush()
    qfile_tmp.close()
    os.rename(qfilename + '.tmp', qfilename)
    return lines[0]

def push(qfilename, args):
    """Add one or more lines to the queue"""
    qfile = open(qfilename, 'r')
    current_lines = qfile.readlines()
    qfile.close()
    qfile_tmp = open(qfilename + '.tmp', 'w')
    qfile_tmp.writelines([line + '\n' for line in args] + current_lines)
    qfile_tmp.flush()
    qfile_tmp.close()
    os.rename(qfilename + '.tmp', qfilename)
    return args[0]

def pop(qfilename, args):
    """Remove the top item from the specified queue and push it onto the .done queue for that file"""
    qfile = open(qfilename, 'r')
    current_lines = qfile.readlines()
    qfile.close()

    if not len(current_lines): return '\n'

    _assure_exists(qfilename + '.done')
    push(qfilename + '.done', [current_lines[0].rstrip()])

    qfile_tmp = open(qfilename + '.tmp', 'w')
    qfile_tmp.writelines(current_lines[1:])
    qfile_tmp.flush()
    qfile_tmp.close()
    os.rename(qfilename + '.tmp', qfilename)
    if len(current_lines) > 1:
        return current_lines[1]
    return '\n'

def _assure_exists(qfilename):
    if not os.path.exists(qfilename):
        open(qfilename, 'w+').close()

def _command_list():
    funcs = globals()
    return dict([(command, funcs[command]) for command in funcs if command[0] != '_' and callable(funcs[command])])

def _commandline_usage(script_name):
    print 'usage:', script_name, 'queuename [command [params]]'
    print '  commands:'
    commands = _command_list()
    for command in commands:
        print '   ', command.ljust(10), commands[command].__doc__
        

def _main():
    import sys
    arg_count = len(sys.argv)
    if arg_count < 2:
        return _commandline_usage(sys.argv[0])

    qdir = os.path.expanduser('~') + '/.q'
    qfilename = qdir + '/' + sys.argv[1]
    if arg_count < 3:
        command_name = 'next'
    else:
        command_name = sys.argv[2]
    
    try:
        command = _command_list()[command_name]
    except NameError, e:
        print e
        return _commandline_usage(sys.argv[0])


    if not os.path.exists(qdir):
        os.mkdir(qdir)
    _assure_exists(qfilename)
    print command(qfilename, sys.argv[3:]),

if __name__=='__main__': 
    _main()
