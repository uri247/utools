import os
import glob
import re


known_shows = [
    'Ali.G.Rezurection',
    'Californication',
    'Cosmos.A.Space.Time.Odyssey',
    'Orphan.Black',
    'Episodes',
    'Fargo',
    'Game.of.Thrones',
    'Greys.Anatomy',
    'Mad.Men',
    'Modern.Family',
    'Nashville.2012',
    'Nurse.Jackie',
    'Parks.and.Recreation',
    'Portlandia',
    'Scandal.US',
    'Shameless.US',
    'The.Goldbergs.2013',
    'The.Good.Wife',
    'The.Voice',
    'Veep',
    ]

known_talkshow = [
    'The.Colbert.Report',
    'The.Daily.Show',
    'David.Letterman',
    'Jimmy.Fallon',
    'Seth.Meyers',
]

special_show = [
    'Saturday.Night.Live',
    'Real.Time.with.Bill.Maher',
]


def my_rename(src, target):
    if src == target:
        print '%-80sgood' % src
    else:
        print '%-80s => %s' % (src, target)
        try:
            os.rename(file_name, target_name)
        except WindowsError as x:
            print 'ERROR:', x


g = glob.glob('*.mp4')
for file_name in g:
    result = re.match(r'(.+)\.(S\d\dE\d\d)(\..*)?\.mp4', file_name)
    if result:
        series, episode, _ = result.groups()
        if series in known_shows:
            target_name = '%s.%s.mp4' % (series, episode)
            my_rename(file_name, target_name)
        else:
            print 'UNKNOWN SHOW:', file_name
    else:
        result = re.match(r'(.+)\.(\d\d\d\d\.\d\d\.\d\d)\.(.*)(\.HDTV)?.*.mp4', file_name)
        if result:
            series, date, guest, _ = result.groups()
            if series in known_talkshow:
                target_name = '%s.%s.%s.mp4' % (series, date, guest)
                my_rename(file_name, target_name)
            else:
                print 'UNKNOWN TALK SHOW:', file_name
        else:
            print 'CAN\'T PARSE:', file_name
