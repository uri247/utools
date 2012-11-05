import boto
import os
import itertools
import re
import argparse

#localpath = r'c:/local/media/photos/ufr'
#bucket = 'ufr'
#limit = 1000000
#excl_f_rex = re.compile( 'Thumbs.db|\.mov|\.MOV' )
#excl_d_rex = re.compile( '----')

s3 = ufr = keys = None
sky_list = dict()
sky_fldrs = dict()
local_list = list()


def connect():
    global s3, ufr, keys
    s3 = boto.connect_s3()
    #ufr = s3.create_bucket(bucket)
    ufr = s3.get_bucket(bucket)
    keys = ufr.list()
    pass
    
    
def get_sky_list():
    """
    populates the sky_list global dictionary
    each item in the list is an tuple with the following format:
    (folder, tail, name, size, k)
    folder - the root folder (e.g. album name for the photoalbum ufr
    tail - the rest of the path
    name - full path to the item
    size - size in bytes
    k - the boto key object
    """
    for index, k in enumerate(keys):
        if(index == limit):
            break
        if excl_f_rex and excl_f_rex.search(k.name):
            continue
        folder, _, tail = k.name.partition('/')
        item = (folder, tail, k.name, k.size, k)
        if k.size > 0:
            sky_list[k.name] = item


def group_sky_by_folders():
    sky_list_sorted = sorted(sky_list.values(), key=lambda item: item[2])
    
    for fldrnm, ls_it in itertools.groupby(sky_list_sorted, lambda item: item[0]):
        ls = list(ls_it)
        total_size = sum(item[3] for item in ls)
        sky_fldrs[fldrnm] = (fldrnm, list(ls), total_size)      

def print_sky_folders():
    for k in sorted(sky_fldrs.keys()):
        fldrnm, ls, total_size = sky_fldrs[k]
        print '{0:<54s}{1:3} files  {2:>12,} bytes'.format(fldrnm, len(ls), total_size)

def get_local_list():
    """
    populate local_list. each record has:
    (rel_path, size)
    """
    for r, ds, fs in os.walk(localpath):
        for f in fs:
            if excl_f_rex and excl_f_rex.search( f ):
                continue        
            full_path = os.path.join(r, f)
            rel_path = os.path.relpath(full_path, localpath).replace('\\', '/')
            item = (rel_path, os.path.getsize(full_path))
            local_list.append(item)
        for d in ds:
            if excl_d_rex and excl_d_rex.search( d ):
                ds.remove(d)

def get_missings():
    """
    generates sky_not_in_local and local_not_in_sky
    """
    global sky_not_in_local, local_not_in_sky
    
    localNames = set([localName for localName, _ in local_list])
    
    sky_not_in_local = [skyName for skyName in sky_list.keys() if skyName not in localNames]
    local_not_in_sky = [localName for localName in localNames if localName not in sky_list]
    
    sky_not_in_local.sort();
    local_not_in_sky.sort();
    
    print 'files in sky missing here:'
    for skyName in sky_not_in_local:
        print '  - {0}'.format(skyName)   
    print 'files locally missing from sky:'
    for localName in local_not_in_sky:
        print '  - {0}'.format(localName)
    
def create_folders_for_fname_and_norm(fname):
    full_path = os.path.normpath(os.path.join(localpath, fname))
    node = os.path.normpath(localpath)
    while True:
        head, sep, tail = fname.partition('/')
        if(not sep):
            break;
        node = os.path.join(node, head)
        fname = tail
        if not os.path.isdir(node):
            os.mkdir(node)
    return full_path

def sync_dn():
    for skyFile in sky_not_in_local:
        localFilename = create_folders_for_fname_and_norm(skyFile)
        _, _, _, _, k = sky_list[skyFile]
        print "... copying {0} ==> {1}".format(skyFile, localFilename)
        k.get_contents_to_filename(localFilename)
        
def sync_up():
    for localFile in local_not_in_sky:
        localFilename = os.path.normpath(os.path.join(localpath, localFile))
        print "... uploading {0}".format(localFile)
        k = ufr.new_key(localFile)
        k.set_contents_from_filename(localFilename)
        k.set_acl('public-read')
    
def prompt_to_sync_loop():
    while True:
        answer = raw_input('do you want to sync (quit|up|down|both)? ')
        if(answer == 'up'):
            sync_up()
        elif(answer == 'down'):
            sync_dn()
        elif(answer == 'both'):
            sync_up()
            sync_dn()
        elif(answer == 'quit'):
            break
        pass
    pass

def parse_cmdline():
    global bucket, localpath, limit, excl_f_rex, excl_d_rex
    parser = argparse.ArgumentParser( prog='S3Sync' )
    parser.add_argument( '-x', '--exlucde', action='append', dest='xlist' )
    parser.add_argument( '-s', '--skip', action='append', dest='slist' )
    parser.add_argument( '-l', '--limit', action='store', default=1000000, type=int )
    parser.add_argument( 'bucket', metavar='bucket name', default='ufr' )
    parser.add_argument( 'directory', metavar='local directory', default='.' )
    parser.print_help()
    ns = parser.parse_args()
    bucket = ns.bucket
    localpath = ns.directory
    limit = ns.limit
    
    if ns.xlist:
        xf = '|'.join(ns.xlist)
        excl_f_rex = re.compile( xf )
    else:
        excl_f_rex = None

    if ns.slist:
        xd = '|'.join(ns.slist)
        excl_d_rex = re.compile( xd )
    else:
        excl_d_rex = None
        

def main():
    parse_cmdline()
    connect()
    get_sky_list()
    group_sky_by_folders()
    print_sky_folders()
    get_local_list()
    get_missings()
    prompt_to_sync_loop()

if __name__ == '__main__':
    main()
    
