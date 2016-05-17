import os
import glob
import re


known_shows = [
    '24',
    'Ali.G.Rezurection',
    'Better.Call.Saul',
    'Billions',
    'Californication',
    'Cosmos.A.Space.Time.Odyssey',
    'Derek',
    'Episodes',
    'Extant',
    'Fargo',
    'Game.of.Thrones',
    'Greys.Anatomy',
    'Homeland',
    'Horace.and.Pete',
    'House.of.Cards.2013',
    'Inside.Amy.Schumer',
    'Last.Week.Tonight.With.John.Oliver',
    'Louie',
    'Mad.Men',
    'Modern.Family',
    'Mozart.In.The.Jungle',
    'Nashville.2012',
    'Nurse.Jackie',
    'Orange.is.the.New.Black',
    'Orphan.Black',
    'Outlander',
    'Parks.and.Recreation',
    'Portlandia',
    'Ray.Donovan',
    'Scandal.US',
    'Shameless.US',
    'The.Affair',
    'The.Americans.2013',
    'The.Catch.US',
    'The.Comedians.US',
    'The.Girlfriend.Experience',
    'The.Goldbergs.2013',
    'The.Good.Wife',
    'The.Leftovers',
    'The.Voice',
    'The.X-Files',
    'Transparent',
    'UnReal',
    'Veep',
    'Vinyl',
    ]

known_talkshow = [
    'The.Colbert.Report',
    'The.Daily.Show',
    'David.Letterman',
    'Jimmy.Fallon',
    'Real.Time.with.Bill.Maher',
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


g = glob.glob('*.mp4') + glob.glob('*.avi') + glob.glob('*.mkv')
for file_name in g:
    result = re.match(r'(.+)\.([Ss]\d\d[Ee]\d\d)(\..*)?\.(mp4|avi|mkv)', file_name)
    if result:
        series, episode, _, ext = result.groups()
        episode = episode.upper()
        if series in known_shows:
            target_name = '%s.%s.%s' % (series, episode, ext)
            my_rename(file_name, target_name)
        else:
            print 'UNKNOWN SHOW:', file_name
    else:
        result = re.match(r'(.+)\.(\d\d\d\d\.\d\d\.\d\d)\.(.*)(\.HDTV)?.*.(mp4|avi)', file_name)
        if result:
            series, date, guest, _, ext = result.groups()
            if series in known_talkshow:
                target_name = '%s.%s.%s.%s' % (series, date, guest, ext)
                my_rename(file_name, target_name)
            else:
                print 'UNKNOWN TALK SHOW:', file_name
        else:
            print 'CAN\'T PARSE:', file_name
