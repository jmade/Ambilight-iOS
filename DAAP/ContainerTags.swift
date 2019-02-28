import Foundation

public struct DMAP {
    public enum DataType { case dict,data,vers,int,uint,date,str,unknown }
    public let type:DataType
    public let name:String
    public let word:String
}

public func findValue(_ word:String) -> DMAP.DataType {
    if let foundType = DAAP_Codes.first(where: { $0.word == word })?.type {
        return foundType
    } else {
        return .unknown
    }
}

public func findName(_ word:String) -> String {
    if let foundName = DAAP_Codes.first(where: { $0.word == word })?.name {
        return foundName
    } else {
        return "None Found"
    }
}

public let DAAP_Codes: [DMAP] = [
    DMAP(type: .vers, name: "dmcp.protocolversion", word: "cmpr"),
    DMAP(type: .dict, name: "com.apple.itunes.photos.faces", word: "pefc"),
    DMAP(type: .uint, name: "dmap.databasekind", word: "mdbk"),
    DMAP(type: .str, name: "dmap.contentcodesname", word: "mcna"),
    DMAP(type: .uint, name: "daap.baseplaylist", word: "abpl"),
    DMAP(type: .date, name: "daap.songdateplayed", word: "aspl"),
    DMAP(type: .dict, name: "daap.resolveinfo", word: "arif"),
    DMAP(type: .str, name: "daap.songgenre", word: "asgn"),
    DMAP(type: .uint, name: "daap.songgapless", word: "asgp"),
    DMAP(type: .uint, name: "daap.supportsgroups", word: "asgr"),
    DMAP(type: .dict, name: "daap.databasebrowse", word: "abro"),
    DMAP(type: .uint, name: "com.apple.itunes.norm-volume", word: "aeNV"),
    DMAP(type: .uint, name: "com.apple.itunes.can-be-genius-seed", word: "aeGs"),
    DMAP(type: .dict, name: "dmap.bag", word: "mbcl"),
    DMAP(type: .uint, name: "com.apple.itunes.non-drm-user-id", word: "aeND"),
    DMAP(type: .str, name: "com.apple.itunes.network-name", word: "aeNN"),
    DMAP(type: .uint, name: "com.apple.itunes.gapless-resy", word: "aeGR"),
    DMAP(type: .uint, name: "dpap.imagelargefilesize", word: "plsz"),
    DMAP(type: .uint, name: "com.apple.itunes.gapless-dur", word: "aeGU"),
    DMAP(type: .uint, name: "dpap.imagepixelwidth", word: "pwth"),
    DMAP(type: .str, name: "dpap.imagefilename", word: "pimf"),
    DMAP(type: .uint, name: "com.apple.itunes.itms-genreid", word: "aeGI"),
    DMAP(type: .uint, name: "com.apple.itunes.gapless-heur", word: "aeGH"),
    DMAP(type: .uint, name: "com.apple.itunes.gapless-enc-del", word: "aeGE"),
    DMAP(type: .uint, name: "com.apple.itunes.gapless-enc-dr", word: "aeGD"),
    DMAP(type: .uint, name: "daap.songbitrate", word: "asbr"),
    DMAP(type: .uint, name: "dmap.specifiedtotalcount", word: "mtco"),
    DMAP(type: .uint, name: "daap.songbeatsperminute", word: "asbt"),
    DMAP(type: .str, name: "com.apple.itunes.episode-num-str", word: "aeEN"),
    DMAP(type: .uint, name: "com.apple.itunes.rental-pb-duration", word: "aeRU"),
    DMAP(type: .uint, name: "com.apple.itunes.episode-sort", word: "aeES"),
    DMAP(type: .uint, name: "com.apple.itunes.rental-pb-start", word: "aeRP"),
    DMAP(type: .uint, name: "com.apple.itunes.rental-start", word: "aeRS"),
    DMAP(type: .uint, name: "daap.bookmarkable", word: "asbk"),
    DMAP(type: .uint, name: "daap.songbookmark", word: "asbo"),
    DMAP(type: .uint, name: "dmap.supportsautologout", word: "msal"),
    DMAP(type: .uint, name: "com.apple.itunes.photos.key-image-id", word: "peki"),
    DMAP(type: .uint, name: "daap.songartistid", word: "asri"),
    DMAP(type: .vers, name: "dmap.protocolversion", word: "mpro"),
    DMAP(type: .uint, name: "daap.songuserratingstatus", word: "asrs"),
    DMAP(type: .int, name: "daap.songrelativevolume", word: "asrv"),
    DMAP(type: .uint, name: "dmap.persistentid", word: "mper"),
    DMAP(type: .uint, name: "dmap.supportsquery", word: "msqy"),
    DMAP(type: .uint, name: "daap.supportsextradata", word: "ated"),
    DMAP(type: .dict, name: "dmap.listing", word: "mlcl"),
    DMAP(type: .dict, name: "dmap.serverinforesponse", word: "msrv"),
    DMAP(type: .uint, name: "dacp.availableshufflestates", word: "caas"),
    DMAP(type: .uint, name: "dacp.availablerepeatstates", word: "caar"),
    DMAP(type: .uint, name: "daap.songuserplaycount", word: "aspc"),
    DMAP(type: .uint, name: "daap.songyear", word: "asyr"),
    DMAP(type: .uint, name: "dmap.supportsresolve", word: "msrs"),
    DMAP(type: .uint, name: "com.apple.itunes.itms-composerid", word: "aeCI"),
    DMAP(type: .date, name: "com.apple.itunes.photos.modification-date", word: "pemd"),
    DMAP(type: .date, name: "dpap.creationdate", word: "picd"),
    DMAP(type: .uint, name: "com.apple.itunes.drm-user-id", word: "aeDR"),
    DMAP(type: .uint, name: "com.apple.itunes.is-podcast", word: "aePC"),
    DMAP(type: .uint, name: "com.apple.itunes.drm-platform-id", word: "aeDP"),
    DMAP(type: .date, name: "daap.songdatepurchased", word: "asdp"),
    DMAP(type: .date, name: "daap.songdatereleased", word: "asdr"),
    DMAP(type: .uint, name: "com.apple.itunes.itms-playlistid", word: "aePI"),
    DMAP(type: .str, name: "daap.songdescription", word: "asdt"),
    DMAP(type: .str, name: "dmap.statusstring", word: "msts"),
    DMAP(type: .uint, name: "com.apple.itunes.special-playlist", word: "aePS"),
    DMAP(type: .uint, name: "com.apple.itunes.is-podcast-playlist", word: "aePP"),
    DMAP(type: .uint, name: "daap.songdatakind", word: "asdk"),
    DMAP(type: .date, name: "daap.songdatemodified", word: "asdm"),
    DMAP(type: .uint, name: "daap.songdiscnumber", word: "asdn"),
    DMAP(type: .date, name: "daap.songdateadded", word: "asda"),
    DMAP(type: .uint, name: "daap.songdisabled", word: "asdb"),
    DMAP(type: .uint, name: "daap.songdisccount", word: "asdc"),
    DMAP(type: .str, name: "dmap.itemname", word: "minm"),
    DMAP(type: .dict, name: "dpap.filedata", word: "pfdt"),
    DMAP(type: .uint, name: "daap.songuserskipcount", word: "askp"),
    DMAP(type: .uint, name: "daap.songtracknumber", word: "astn"),
    DMAP(type: .str, name: "daap.songpodcasturl", word: "aspu"),
    DMAP(type: .uint, name: "dmap.authenticationschemes", word: "msas"),
    DMAP(type: .uint, name: "daap.songtrackcount", word: "astc"),
    DMAP(type: .str, name: "daap.songkeywords", word: "asky"),
    DMAP(type: .date, name: "daap.songlastskipdate", word: "askd"),
    DMAP(type: .dict, name: "dpap.retryids", word: "pret"),
    DMAP(type: .uint, name: "dmap.itemkind", word: "mikd"),
    DMAP(type: .uint, name: "dmap.serverrevision", word: "musr"),
    DMAP(type: .dict, name: "caci", word: "caci"),
    DMAP(type: .uint, name: "daap.groupalbumcount", word: "agac"),
    DMAP(type: .uint, name: "dacp.shufflestate", word: "cash"),
    DMAP(type: .uint, name: "dacp.songtime", word: "cast"),
    DMAP(type: .dict, name: "dacp.speakers", word: "casp"),
    DMAP(type: .uint, name: "dmap.supportspersistentids", word: "mspi"),
    DMAP(type: .uint, name: "com.apple.itunes.drm-key2-id", word: "aeK2"),
    DMAP(type: .uint, name: "com.apple.itunes.drm-key1-id", word: "aeK1"),
    DMAP(type: .str, name: "dacp.nowplayinggenre", word: "cang"),
    DMAP(type: .uint, name: "daap.groupmatchedqueryalbumcount", word: "agma"),
    DMAP(type: .str, name: "dacp.nowplayingartist", word: "cana"),
    DMAP(type: .str, name: "dacp.nowplayingname", word: "cann"),
    DMAP(type: .str, name: "dacp.nowplayingalbum", word: "canl"),
    DMAP(type: .uint, name: "daap.groupmatchedqueryitemcount", word: "agmi"),
    DMAP(type: .uint, name: "dacp.nowplayingtime", word: "cant"),
    DMAP(type: .dict, name: "daap.browsecomposerlisting", word: "abcp"),
    DMAP(type: .uint, name: "dacp.nowplayingids", word: "canp"),
    DMAP(type: .uint, name: "daap.songprimaryvideocodec", word: "asvc"),
    DMAP(type: .uint, name: "dmap.machineaddress", word: "msma"),
    DMAP(type: .dict, name: "msml", word: "msml"),
    DMAP(type: .uint, name: "dmap.itemid", word: "miid"),
    DMAP(type: .uint, name: "dmap.databasescount", word: "msdc"),
    DMAP(type: .dict, name: "dmap.contentcodesresponse", word: "mccr"),
    DMAP(type: .str, name: "dpap.imageformat", word: "pfmt"),
    DMAP(type: .str, name: "dpap.aspectratio", word: "pasp"),
    DMAP(type: .uint, name: "daap.songhasbeenplayed", word: "ashp"),
    DMAP(type: .dict, name: "daap.resolve", word: "arsv"),
    DMAP(type: .dict, name: "daap.playlistsongs", word: "apso"),
    DMAP(type: .dict, name: "daap.serverdatabases", word: "avdb"),
    DMAP(type: .uint, name: "dmap.remotepersistentid", word: "mrpr"),
    DMAP(type: .dict, name: "daap.databaseplaylists", word: "aply"),
    DMAP(type: .dict, name: "daap.browsealbumlisting", word: "abal"),
    DMAP(type: .dict, name: "daap.browseartistlisting", word: "abar"),
    DMAP(type: .dict, name: "daap.databasesongs", word: "adbs"),
    DMAP(type: .uint, name: "dmap.updatetype", word: "muty"),
    DMAP(type: .uint, name: "dpap.imagerating", word: "prat"),
    DMAP(type: .uint, name: "dmap.status", word: "mstt"),
    DMAP(type: .uint, name: "dmap.parentcontainerid", word: "mpco"),
    DMAP(type: .uint, name: "dmap.downloadstatus", word: "mdst"),
    DMAP(type: .dict, name: "dmap.listingitem", word: "mlit"),
    DMAP(type: .vers, name: "dacp.protocolversion", word: "capr"),
    DMAP(type: .uint, name: "dacp.playerstate", word: "caps"),
    DMAP(type: .uint, name: "dmap.sessionid", word: "mlid"),
    DMAP(type: .uint, name: "dmap.containeritemid", word: "mcti"),
    DMAP(type: .uint, name: "dmap.timeoutinterval", word: "mstm"),
    DMAP(type: .str, name: "daap.songformat", word: "asfm"),
    DMAP(type: .uint, name: "dmap.containercount", word: "mctc"),
    DMAP(type: .dict, name: "dmcp.getpropertyresponse", word: "cmgt"),
    DMAP(type: .int, name: "dmap.utcoffset", word: "msto"),
    DMAP(type: .uint, name: "dmap.contentcodestype", word: "mcty"),
    DMAP(type: .dict, name: "dmap.dictionary", word: "mdcl"),
    DMAP(type: .str, name: "com.apple.itunes.movie-info-xml", word: "aeMX"),
    DMAP(type: .dict, name: "daap.browsegenrelisting", word: "abgn"),
    DMAP(type: .uint, name: "com.apple.itunes.jukebox-current", word: "ceJI"),
    DMAP(type: .uint, name: "com.apple.itunes.jukebox-client-vote", word: "ceJC"),
    DMAP(type: .uint, name: "com.apple.itunes.mediakind", word: "aeMK"),
    DMAP(type: .uint, name: "com.apple.itunes.jukebox-vote", word: "ceJV"),
    DMAP(type: .uint, name: "com.apple.itunes.playlist-contains-media-type-count", word: "aeMC"),
    DMAP(type: .uint, name: "com.apple.itunes.jukebox-score", word: "ceJS"),
    DMAP(type: .uint, name: "dmap.returnedcount", word: "mrco"),
    DMAP(type: .uint, name: "dmap.supportsindex", word: "msix"),
    DMAP(type: .uint, name: "dmap.contentcodesnumber", word: "mcnm"),
    DMAP(type: .uint, name: "dmap.editcommandssupported", word: "meds"),
    DMAP(type: .uint, name: "com.apple.itunes.extended-media-kind", word: "aeMk"),
    DMAP(type: .date, name: "dmap.utctime", word: "mstc"),
    DMAP(type: .uint, name: "daap.songalbumuserratingstatus", word: "asas"),
    DMAP(type: .str, name: "daap.songartist", word: "asar"),
    DMAP(type: .dict, name: "com.apple.itunes.playqueue-contents-response", word: "ceQR"),
    DMAP(type: .uint, name: "dacp.repeatstate", word: "carp"),
    DMAP(type: .date, name: "com.apple.itunes.photos.exposure-date", word: "peed"),
    DMAP(type: .uint, name: "com.apple.itunes.drm-versions", word: "aeDV"),
    DMAP(type: .uint, name: "dmap.itemcount", word: "mimc"),
    DMAP(type: .uint, name: "daap.songartworkcount", word: "asac"),
    DMAP(type: .str, name: "daap.songalbumartist", word: "asaa"),
    DMAP(type: .str, name: "daap.songalbum", word: "asal"),
    DMAP(type: .uint, name: "daap.songalbumid", word: "asai"),
    DMAP(type: .uint, name: "daap.songtime", word: "astm"),
    DMAP(type: .dict, name: "dmap.container", word: "mcon"),
    DMAP(type: .dict, name: "dpap.failureids", word: "pfai"),
    DMAP(type: .str, name: "com.apple.itunes.playqueue-artist", word: "ceQr"),
    DMAP(type: .str, name: "com.apple.itunes.playqueue-name", word: "ceQn"),
    DMAP(type: .uint, name: "dacp.isactive", word: "caia"),
    DMAP(type: .str, name: "com.apple.itunes.playqueue-album", word: "ceQa"),
    DMAP(type: .str, name: "com.apple.itunes.playqueue-genre", word: "ceQg"),
    DMAP(type: .dict, name: "dmap.deletedidlisting", word: "mudl"),
    DMAP(type: .uint, name: "com.apple.itunes.photos.album-kind", word: "peak"),
    DMAP(type: .uint, name: "com.apple.itunes.rental-duration", word: "aeRD"),
    DMAP(type: .uint, name: "dmap.supportsupdate", word: "msup"),
    DMAP(type: .uint, name: "dmcp.mediakind", word: "cmmk"),
    DMAP(type: .str, name: "daap.songgrouping", word: "agrp"),
    DMAP(type: .dict, name: "dmap.updateresponse", word: "mupd"),
    DMAP(type: .str, name: "com.apple.itunes.xid", word: "aeXD"),
    DMAP(type: .uint, name: "dmap.authenticationmethod", word: "msau"),
    DMAP(type: .vers, name: "dpap.protocolversion", word: "ppro"),
    DMAP(type: .uint, name: "com.apple.itunes.saved-genius", word: "aeSG"),
    DMAP(type: .uint, name: "com.apple.itunes.itms-storefrontid", word: "aeSF"),
    DMAP(type: .uint, name: "com.apple.itunes.store-pers-id", word: "aeSE"),
    DMAP(type: .str, name: "com.apple.itunes.series-name", word: "aeSN"),
    DMAP(type: .uint, name: "dmcp.serverrevision", word: "cmsr"),
    DMAP(type: .uint, name: "dmap.supportsbrowse", word: "msbr"),
    DMAP(type: .str, name: "daap.songcomposer", word: "ascp"),
    DMAP(type: .uint, name: "com.apple.itunes.itms-songid", word: "aeSI"),
    DMAP(type: .uint, name: "daap.songcontentrating", word: "ascr"),
    DMAP(type: .dict, name: "com.apple.itunes.media-kind-listing-item", word: "aemi"),
    DMAP(type: .vers, name: "com.apple.itunes.music-sharing-version", word: "aeSV"),
    DMAP(type: .uint, name: "com.apple.itunes.season-num", word: "aeSU"),
    DMAP(type: .uint, name: "com.apple.itunes.cloud-id", word: "aeCd"),
    DMAP(type: .dict, name: "com.apple.itunes.media-kind-listing", word: "aeml"),
    DMAP(type: .uint, name: "com.apple.itunes.smart-playlist", word: "aeSP"),
    DMAP(type: .uint, name: "daap.songcodectype", word: "ascd"),
    DMAP(type: .uint, name: "dpap.imagepixelheight", word: "phgt"),
    DMAP(type: .str, name: "daap.sortalbumartist", word: "assl"),
    DMAP(type: .uint, name: "com.apple.itunes.cloud-user-id", word: "aeCU"),
    DMAP(type: .str, name: "daap.sortname", word: "assn"),
    DMAP(type: .uint, name: "com.apple.itunes.artworkchecksum", word: "aeCS"),
    DMAP(type: .str, name: "com.apple.itunes.content-rating", word: "aeCR"),
    DMAP(type: .str, name: "daap.sortartist", word: "assa"),
    DMAP(type: .str, name: "daap.sortcomposer", word: "assc"),
    DMAP(type: .uint, name: "com.apple.itunes.cloud-flavor-id", word: "aeCF"),
    DMAP(type: .data, name: "com.apple.itunes.flat-chapter-data", word: "aeCD"),
    DMAP(type: .uint, name: "daap.songsize", word: "assz"),
    DMAP(type: .str, name: "daap.sortalbum", word: "assu"),
    DMAP(type: .uint, name: "daap.songstarttime", word: "asst"),
    DMAP(type: .uint, name: "com.apple.itunes.cloud-status", word: "aeCM"),
    DMAP(type: .uint, name: "com.apple.itunes.cloud-library-kind", word: "aeCK"),
    DMAP(type: .uint, name: "daap.songstoptime", word: "assp"),
    DMAP(type: .str, name: "daap.sortseriesname", word: "asss"),
    DMAP(type: .uint, name: "daap.songsamplerate", word: "assr"),
    DMAP(type: .uint, name: "dmcp.volume", word: "cmvo"),
    DMAP(type: .uint, name: "daap.playlistrepeatmode", word: "aprm"),
    DMAP(type: .vers, name: "daap.protocolversion", word: "apro"),
    DMAP(type: .uint, name: "dacp.fullscreen", word: "cafs"),
    DMAP(type: .uint, name: "dpap.imagefilesize", word: "pifs"),
    DMAP(type: .uint, name: "dmap.supportsextensions", word: "msex"),
    DMAP(type: .uint, name: "dacp.fullscreenenabled", word: "cafe"),
    DMAP(type: .dict, name: "dmap.loginresponse", word: "mlog"),
    DMAP(type: .uint, name: "dacp.visualizerenabled", word: "cave"),
    DMAP(type: .uint, name: "dacp.volumecontrollable", word: "cavc"),
    DMAP(type: .str, name: "daap.songlongcontentdescription", word: "aslc"),
    DMAP(type: .str, name: "daap.songcategory", word: "asct"),
    DMAP(type: .uint, name: "dacp.visualizer", word: "cavs"),
    DMAP(type: .uint, name: "daap.songexcludefromshuffle", word: "ases"),
    DMAP(type: .uint, name: "com.apple.itunes.has-chapter-data", word: "aeHC"),
    DMAP(type: .str, name: "daap.songeqpreset", word: "aseq"),
    DMAP(type: .uint, name: "daap.playlistshufflemode", word: "apsm"),
    DMAP(type: .uint, name: "com.apple.itunes.is-hd-video", word: "aeHD"),
    DMAP(type: .dict, name: "dmcp.playstatus", word: "cmst"),
    DMAP(type: .dict, name: "dpap.iphotoslideshowadvancedoptions", word: "ipsa"),
    DMAP(type: .uint, name: "daap.songcodecsubtype", word: "ascs"),
    DMAP(type: .dict, name: "com.apple.itunes.adam-ids-array", word: "aeAD"),
    DMAP(type: .uint, name: "com.apple.itunes.has-video", word: "aeHV"),
    DMAP(type: .dict, name: "dpap.iphotoslideshowoptions", word: "ipsl"),
    DMAP(type: .uint, name: "daap.songextradata", word: "ased"),
    DMAP(type: .str, name: "daap.songcomment", word: "ascm"),
    DMAP(type: .uint, name: "daap.songalbumuserrating", word: "aslr"),
    DMAP(type: .uint, name: "daap.songlongsize", word: "asls"),
    DMAP(type: .uint, name: "dmap.loginrequired", word: "mslr"),
    DMAP(type: .str, name: "daap.songdataurl", word: "asul"),
    DMAP(type: .str, name: "dpap.imagecomments", word: "pcmt"),
    DMAP(type: .uint, name: "daap.songcompilation", word: "asco"),
    DMAP(type: .str, name: "daap.songcontentdescription", word: "ascn"),
    DMAP(type: .uint, name: "com.apple.itunes.itms-artistid", word: "aeAI"),
    DMAP(type: .uint, name: "daap.songuserrating", word: "asur"),
]


public enum ContainerTag: String {
    /* Container tags */
    case  daap_mcon       = "6d636f6e"
    case  daap_msrv       = "6d737276"
    case  daap_mccr       = "6d636372"
    case  daap_mdcl       = "6d64636c"
    case  daap_mlog       = "6d6c6f67"
    case  daap_mupd       = "6d757064"
    case  daap_avdb       = "61766462"
    case  daap_mlcl       = "6d6c636c"
    case  daap_mlit       = "6d6c6974"
    case  daap_mbcl       = "6d62636c"
    case  daap_adbs       = "61646273"
    case  daap_aply       = "61706c79"
    case  daap_apso       = "6170736f"
    case  daap_mudl       = "6d75646c"
    case  daap_abro       = "6162726f"
    case  daap_abar       = "61626172"
    case  daap_arsv       = "61727376"
    case  daap_abal       = "6162616c"
    case  daap_abcp       = "61626370"
    case  daap_abgn       = "6162676e"
    case  daap_prsv       = "70727376"
    case  daap_arif       = "61726966"
    case  daap_mctc       = "6d637463"
    case  dacp_casp       = "63617370"
    case  dacp_cmst       = "636d7374"
    case  dacp_cmgt       = "636d6774"
    
    /* String tags */
    case  daap_minm       = "6d696e6d"
    case  daap_msts       = "6d737473"
    case  daap_mcnm       = "6d636e6d"
    case  daap_mcna       = "6d636e61"
    case  daap_asal       = "6173616c"
    case  daap_asar       = "61736172"
    case  daap_ascm       = "6173636d"
    case  daap_asfm       = "6173666d"
    case  daap_aseq       = "61736571"
    case  daap_asgn       = "6173676e"
    case  daap_asdt       = "61736474"
    case  daap_asul       = "6173756c"
    case  daap_ascp       = "61736370"
    case  daap_asct       = "61736374"
    case  daap_ascn       = "6173636e"
    case  daap_aslc       = "61736c63"
    case  daap_asky       = "61736b79"
    case  daap_aeSN       = "6165534e"
    case  daap_aeNN       = "61654e4e"
    case  daap_aeEN       = "6165454e"
    case  daap_assn       = "6173736e"
    case  daap_assa       = "61737361"
    case  daap_assl       = "6173736c"
    case  daap_assc       = "61737363"
    case  daap_asss       = "61737373"
    case  daap_asaa       = "61736161"
    case  daap_aspu       = "61737075"
    case  daap_aeCR       = "61654352"
    case  dacp_cana       = "63616e61"
    case  dacp_cang       = "63616e67"
    case  dacp_canl       = "63616e6c"
    case  dacp_cann       = "63616e6e"
    
    /* uint64 tags */
    case  daap_mper       = "6d706572"
    case  daap_aeGU       = "61654755"
    case  daap_aeGR       = "61654752"
    case  daap_asai       = "61736169"
    case  daap_asls       = "61736c73"
    
    /* uint32 tags */
    case  daap_mstt       = "6d737474"
    case  daap_musr       = "6d757372"
    case  daap_miid       = "6d696964"
    case  daap_mcti       = "6d637469"
    case  daap_mpco       = "6d70636f"
    case  daap_mimc       = "6d696d63"
    case  daap_mrco       = "6d72636f"
    case  daap_mtco       = "6d74636f"
    case  daap_mstm       = "6d73746d"
    case  daap_msdc       = "6d736463"
    case  daap_mlid       = "6d6c6964"
    case  daap_msur       = "6d737572"
    case  daap_asda       = "61736461"
    case  daap_asdm       = "6173646d"
    case  daap_assr       = "61737372"
    case  daap_assz       = "6173737a"
    case  daap_asst       = "61737374"
    case  daap_assp       = "61737370"
    case  daap_astm       = "6173746d"
    case  daap_aeNV       = "61654e56"
    case  daap_ascd       = "61736364"
    case  daap_ascs       = "61736373"
    case  daap_aeSV       = "61655356"
    case  daap_aePI       = "61655049"
    case  daap_aeCI       = "61654349"
    case  daap_aeGI       = "61654749"
    case  daap_aeAI       = "61654149"
    case  daap_aeSI       = "61655349"
    case  daap_aeES       = "61654553"
    case  daap_aeSU       = "61655355"
    case  daap_asbo       = "6173626f"
    case  daap_aeGH       = "61654748"
    case  daap_aeGD       = "61654744"
    case  daap_aeGE       = "61654745"
    case  daap_meds       = "6d656473"
    case  dacp_cmsr       = "636d7372"
    case  dacp_cant       = "63616e74"
    case  dacp_cast       = "63617374"
    case  dacp_cmvo       = "636d766f"
    
    /*TODO:
     case  daap_msto       = "6d7374OO utcoffset
     */
    
    /* uint16 tags */
    case  daap_mcty       = "6d637479"
    case  daap_asbt       = "61736274"
    case  daap_asbr       = "61736272"
    case  daap_asdc       = "61736463"
    case  daap_asdn       = "6173646e"
    case  daap_astc       = "61737463"
    case  daap_astn       = "6173746e"
    case  daap_asyr       = "61737972"
    case  daap_ased       = "61736564"
    
    /* byte  tags */
    case  daap_mikd       = "6d696b64"
    case  daap_msau       = "6d736175"
    case  daap_msty       = "6d737479"
    case  daap_asrv       = "61737276"  /* XXX: may be uint16 in newer iTunes versions! */
    case  daap_asur       = "61737572"
    case  daap_asdk       = "6173646b"
    case  daap_muty       = "6d757479"
    case  daap_msas       = "6d736173"
    case  daap_aeHV       = "61654856"
    case  daap_aeHD       = "61654844"
    case  daap_aePC       = "61655043"
    case  daap_aePP       = "61655050"
    case  daap_aeMK       = "61654d4b"
    case  daap_aeSG       = "61655347"
    case  daap_apsm       = "6170736d"
    case  daap_aprm       = "6170726d"
    case  daap_asgp       = "61736770"
    case  daap_aePS       = "61655053"
    case  daap_asbk       = "6173626b"
    case  dacp_cafs       = "63616673"
    case  dacp_caps       = "63617073"
    case  dacp_carp       = "63617270"
    case  dacp_cash       = "63617368"
    case  dacp_cavs       = "63617673"
    
    /* boolean  tags */
    case  daap_mslr       = "6d736c72"
    case  daap_msal       = "6d73616c"
    case  daap_msup       = "6d737570"
    case  daap_mspi       = "6d737069"
    case  daap_msex       = "6d736578"
    case  daap_msbr       = "6d736272"
    case  daap_msqy       = "6d737179"
    case  daap_msix       = "6d736978"
    case  daap_msrs       = "6d737273"
    case  daap_asco       = "6173636f"
    case  daap_asdb       = "61736462"
    case  daap_abpl       = "6162706c"
    case  daap_aeSP       = "61655350"
    case  daap_ashp       = "61736870"
    
    /* version (32-bit)*/
    case  daap_mpro       = "6d70726f"
    case  daap_apro       = "6170726f"
    
    /* now playing */
    case  dacp_canp       = "63616e70"
    case  daap_png        = "89504e47"
    
    /* date/time */
    /* TODO:
     case  daap_mstc = "MMSSTTCC utctime
     case  daap_asdr ("daap.songdatereleased")
     case  daap_asdp ("daap.songdatepurchased")
     */
}
