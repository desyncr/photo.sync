#!/usr/bin/perl -w
use strict;
use warnings;
# photo.sync is a downloader for albums/sets/threads etc.
# ie:
# 	asphyxia@bt:~/projects/photo.sync$ ./sync.pl --url=http://localhost/albums/test.html --destination=/home/asphyxia/downloads/images/albums/
#
#

use album::album;               # Album class (uses Photo class)
use debug::debug;               # Debug class
use config;

my $album = new Album($config::config{target}, $config::config{settings});
if (!$album->update())
{
    print "Error updating album. Check your internet connection.\n";
}
$album->info();
$album->download();
$album->save();


## TODO
# - More comments and over all documentation of the classes (mainly database) WITH USAGE EXAMPLES!!
#
# - Develop test suites (I'm tired of waiting the pages to load as I have to test it live).
#
# - Add more sockets for different sites.
#
# - Use external difinitions for the database schemas / like albums.schema, photos.schema.
#
# - Currently photo.pm (interface / controller) for photos.pm (back end / model) isn't used at all.
#	album.pm uses photos.pm directly with out the interface. I don't know if there is a need for one,
#	since the main controller (sync.pl) won't make use of it anyways. It's like a relationship 'belongs to', meaning
#	photos.pm has no use if not for album.pm
#
# - Need to figure out how to expose the settings globally, or if its a good idea such thing.
#	Currently the settings are passed from one class to another, and they take what they need from it.
#
# x Download images and update its download status and other information from the database.
#       - [Database::Photo::GetOneFromAlbumNotDownloaded()           ->      Network::DownloadFromUrl()         ->      FS::SaveToDownloadLocation()    ]
#               Database::UpdateStatus(image)
#
# x sync.pl should handle params and configuration settings
# x Socket interface to handle different album types (imgsrc, 4chan, photobucket etc)
#       Socket::information()           Retrieve album information from a given url
#       Socket::imagelist()             Retrieve images urls from a given urls
#       Socket::
#       
#       [ Album ]       <---(uses)      [imgsrc.ru socket]      <---(implements) [Socket interface]
#