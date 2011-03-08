#-*-coding:utf-8-*-
"""
Script d'installation de fichiers de configuration
"""
from sys import argv
from os import listdir, system, path

HERE = path.dirname(__file__)

def get_files_dir():
    return path.join(HERE, './files/')
def get_conf_files():
    return [path.join(get_files_dir(), f_name) for f_name in listdir(get_files_dir())if f_name.startswith('.')]

def copy_file(f_name, dest):
    print("/bin/cp -f '%s' '%s' " % (f_name, dest))
    system("/bin/cp -f '%s' '%s' " % (f_name, dest))

def install():
    destination = path.expanduser('~/')

    for f_name in get_conf_files():
        copy_file(f_name, destination)
if __name__ == '__main__':
    print(path.expanduser('~/'))
    install()
