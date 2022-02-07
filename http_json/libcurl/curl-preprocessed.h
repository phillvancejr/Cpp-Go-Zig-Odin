typedef void CURL;
typedef void CURLSH;
typedef int curl_socket_t;






typedef enum {
  CURLSSLBACKEND_NONE = 0,
  CURLSSLBACKEND_OPENSSL = 1,
  CURLSSLBACKEND_GNUTLS = 2,
  CURLSSLBACKEND_NSS = 3,
  CURLSSLBACKEND_OBSOLETE4 = 4,
  CURLSSLBACKEND_GSKIT = 5,
  CURLSSLBACKEND_POLARSSL = 6,
  CURLSSLBACKEND_WOLFSSL = 7,
  CURLSSLBACKEND_SCHANNEL = 8,
  CURLSSLBACKEND_SECURETRANSPORT = 9,
  CURLSSLBACKEND_AXTLS = 10,
  CURLSSLBACKEND_MBEDTLS = 11,
  CURLSSLBACKEND_MESALINK = 12
} curl_sslbackend;
struct curl_httppost {
  struct curl_httppost *next;
  char *name;
  long namelength;
  char *contents;
  long contentslength;

  char *buffer;
  long bufferlength;
  char *contenttype;
  struct curl_slist *contentheader;
  struct curl_httppost *more;


  long flags;
  char *showfilename;


  void *userp;

  curl_off_t contentlen;


};



typedef int (*curl_progress_callback)(void *clientp,
                                      double dltotal,
                                      double dlnow,
                                      double ultotal,
                                      double ulnow);



typedef int (*curl_xferinfo_callback)(void *clientp,
                                      curl_off_t dltotal,
                                      curl_off_t dlnow,
                                      curl_off_t ultotal,
                                      curl_off_t ulnow);
typedef size_t (*curl_write_callback)(char *buffer,
                                      size_t size,
                                      size_t nitems,
                                      void *outstream);


typedef int (*curl_resolver_start_callback)(void *resolver_state,
                                            void *reserved, void *userdata);


typedef enum {
  CURLFILETYPE_FILE = 0,
  CURLFILETYPE_DIRECTORY,
  CURLFILETYPE_SYMLINK,
  CURLFILETYPE_DEVICE_BLOCK,
  CURLFILETYPE_DEVICE_CHAR,
  CURLFILETYPE_NAMEDPIPE,
  CURLFILETYPE_SOCKET,
  CURLFILETYPE_DOOR,

  CURLFILETYPE_UNKNOWN
} curlfiletype;
struct curl_fileinfo {
  char *filename;
  curlfiletype filetype;
  time_t time;
  unsigned int perm;
  int uid;
  int gid;
  curl_off_t size;
  long int hardlinks;

  struct {

    char *time;
    char *perm;
    char *user;
    char *group;
    char *target;
  } strings;

  unsigned int flags;


  char *b_data;
  size_t b_size;
  size_t b_used;
};
typedef long (*curl_chunk_bgn_callback)(const void *transfer_info,
                                        void *ptr,
                                        int remains);
typedef long (*curl_chunk_end_callback)(void *ptr);
typedef int (*curl_fnmatch_callback)(void *ptr,
                                     const char *pattern,
                                     const char *string);






typedef int (*curl_seek_callback)(void *instream,
                                  curl_off_t offset,
                                  int origin);
typedef size_t (*curl_read_callback)(char *buffer,
                                      size_t size,
                                      size_t nitems,
                                      void *instream);

typedef int (*curl_trailer_callback)(struct curl_slist **list,
                                      void *userdata);

typedef enum {
  CURLSOCKTYPE_IPCXN,
  CURLSOCKTYPE_ACCEPT,
  CURLSOCKTYPE_LAST
} curlsocktype;
typedef int (*curl_sockopt_callback)(void *clientp,
                                     curl_socket_t curlfd,
                                     curlsocktype purpose);

struct curl_sockaddr {
  int family;
  int socktype;
  int protocol;
  unsigned int addrlen;


  struct sockaddr addr;
};

typedef curl_socket_t
(*curl_opensocket_callback)(void *clientp,
                            curlsocktype purpose,
                            struct curl_sockaddr *address);

typedef int
(*curl_closesocket_callback)(void *clientp, curl_socket_t item);

typedef enum {
  CURLIOE_OK,
  CURLIOE_UNKNOWNCMD,
  CURLIOE_FAILRESTART,
  CURLIOE_LAST
} curlioerr;

typedef enum {
  CURLIOCMD_NOP,
  CURLIOCMD_RESTARTREAD,
  CURLIOCMD_LAST
} curliocmd;

typedef curlioerr (*curl_ioctl_callback)(CURL *handle,
                                         int cmd,
                                         void *clientp);
typedef void *(*curl_malloc_callback)(size_t size);
typedef void (*curl_free_callback)(void *ptr);
typedef void *(*curl_realloc_callback)(void *ptr, size_t size);
typedef char *(*curl_strdup_callback)(const char *str);
typedef void *(*curl_calloc_callback)(size_t nmemb, size_t size);





typedef enum {
  CURLINFO_TEXT = 0,
  CURLINFO_HEADER_IN,
  CURLINFO_HEADER_OUT,
  CURLINFO_DATA_IN,
  CURLINFO_DATA_OUT,
  CURLINFO_SSL_DATA_IN,
  CURLINFO_SSL_DATA_OUT,
  CURLINFO_END
} curl_infotype;

typedef int (*curl_debug_callback)
       (CURL *handle,
        curl_infotype type,
        char *data,
        size_t size,
        void *userptr);
typedef enum {
  CURLE_OK = 0,
  CURLE_UNSUPPORTED_PROTOCOL,
  CURLE_FAILED_INIT,
  CURLE_URL_MALFORMAT,
  CURLE_NOT_BUILT_IN,

  CURLE_COULDNT_RESOLVE_PROXY,
  CURLE_COULDNT_RESOLVE_HOST,
  CURLE_COULDNT_CONNECT,
  CURLE_WEIRD_SERVER_REPLY,
  CURLE_REMOTE_ACCESS_DENIED,


  CURLE_FTP_ACCEPT_FAILED,

  CURLE_FTP_WEIRD_PASS_REPLY,
  CURLE_FTP_ACCEPT_TIMEOUT,


  CURLE_FTP_WEIRD_PASV_REPLY,
  CURLE_FTP_WEIRD_227_FORMAT,
  CURLE_FTP_CANT_GET_HOST,
  CURLE_HTTP2,


  CURLE_FTP_COULDNT_SET_TYPE,
  CURLE_PARTIAL_FILE,
  CURLE_FTP_COULDNT_RETR_FILE,
  CURLE_OBSOLETE20,
  CURLE_QUOTE_ERROR,
  CURLE_HTTP_RETURNED_ERROR,
  CURLE_WRITE_ERROR,
  CURLE_OBSOLETE24,
  CURLE_UPLOAD_FAILED,
  CURLE_READ_ERROR,
  CURLE_OUT_OF_MEMORY,




  CURLE_OPERATION_TIMEDOUT,
  CURLE_OBSOLETE29,
  CURLE_FTP_PORT_FAILED,
  CURLE_FTP_COULDNT_USE_REST,
  CURLE_OBSOLETE32,
  CURLE_RANGE_ERROR,
  CURLE_HTTP_POST_ERROR,
  CURLE_SSL_CONNECT_ERROR,
  CURLE_BAD_DOWNLOAD_RESUME,
  CURLE_FILE_COULDNT_READ_FILE,
  CURLE_LDAP_CANNOT_BIND,
  CURLE_LDAP_SEARCH_FAILED,
  CURLE_OBSOLETE40,
  CURLE_FUNCTION_NOT_FOUND,
  CURLE_ABORTED_BY_CALLBACK,
  CURLE_BAD_FUNCTION_ARGUMENT,
  CURLE_OBSOLETE44,
  CURLE_INTERFACE_FAILED,
  CURLE_OBSOLETE46,
  CURLE_TOO_MANY_REDIRECTS,
  CURLE_UNKNOWN_OPTION,
  CURLE_TELNET_OPTION_SYNTAX,
  CURLE_OBSOLETE50,
  CURLE_OBSOLETE51,
  CURLE_GOT_NOTHING,
  CURLE_SSL_ENGINE_NOTFOUND,
  CURLE_SSL_ENGINE_SETFAILED,

  CURLE_SEND_ERROR,
  CURLE_RECV_ERROR,
  CURLE_OBSOLETE57,
  CURLE_SSL_CERTPROBLEM,
  CURLE_SSL_CIPHER,
  CURLE_PEER_FAILED_VERIFICATION,

  CURLE_SSL_CACERT = CURLE_PEER_FAILED_VERIFICATION,
  CURLE_BAD_CONTENT_ENCODING,
  CURLE_LDAP_INVALID_URL,
  CURLE_FILESIZE_EXCEEDED,
  CURLE_USE_SSL_FAILED,
  CURLE_SEND_FAIL_REWIND,

  CURLE_SSL_ENGINE_INITFAILED,
  CURLE_LOGIN_DENIED,

  CURLE_TFTP_NOTFOUND,
  CURLE_TFTP_PERM,
  CURLE_REMOTE_DISK_FULL,
  CURLE_TFTP_ILLEGAL,
  CURLE_TFTP_UNKNOWNID,
  CURLE_REMOTE_FILE_EXISTS,
  CURLE_TFTP_NOSUCHUSER,
  CURLE_CONV_FAILED,
  CURLE_CONV_REQD,




  CURLE_SSL_CACERT_BADFILE,

  CURLE_REMOTE_FILE_NOT_FOUND,
  CURLE_SSH,



  CURLE_SSL_SHUTDOWN_FAILED,

  CURLE_AGAIN,


  CURLE_SSL_CRL_BADFILE,

  CURLE_SSL_ISSUER_ERROR,

  CURLE_FTP_PRET_FAILED,
  CURLE_RTSP_CSEQ_ERROR,
  CURLE_RTSP_SESSION_ERROR,
  CURLE_FTP_BAD_FILE_LIST,
  CURLE_CHUNK_FAILED,
  CURLE_NO_CONNECTION_AVAILABLE,

  CURLE_SSL_PINNEDPUBKEYNOTMATCH,

  CURLE_SSL_INVALIDCERTSTATUS,
  CURLE_HTTP2_STREAM,

  CURLE_RECURSIVE_API_CALL,

  CURL_LAST
} CURLcode;
typedef CURLcode (*curl_conv_callback)(char *buffer, size_t length);

typedef CURLcode (*curl_ssl_ctx_callback)(CURL *curl,
                                          void *ssl_ctx,

                                          void *userptr);

typedef enum {
  CURLPROXY_HTTP = 0,

  CURLPROXY_HTTP_1_0 = 1,

  CURLPROXY_HTTPS = 2,
  CURLPROXY_SOCKS4 = 4,

  CURLPROXY_SOCKS5 = 5,
  CURLPROXY_SOCKS4A = 6,
  CURLPROXY_SOCKS5_HOSTNAME = 7


} curl_proxytype;
enum curl_khtype {
  CURLKHTYPE_UNKNOWN,
  CURLKHTYPE_RSA1,
  CURLKHTYPE_RSA,
  CURLKHTYPE_DSS,
  CURLKHTYPE_ECDSA,
  CURLKHTYPE_ED25519
};

struct curl_khkey {
  const char *key;

  size_t len;
  enum curl_khtype keytype;
};



enum curl_khstat {
  CURLKHSTAT_FINE_ADD_TO_FILE,
  CURLKHSTAT_FINE,
  CURLKHSTAT_REJECT,
  CURLKHSTAT_DEFER,


  CURLKHSTAT_LAST
};


enum curl_khmatch {
  CURLKHMATCH_OK,
  CURLKHMATCH_MISMATCH,
  CURLKHMATCH_MISSING,
  CURLKHMATCH_LAST
};

typedef int
  (*curl_sshkeycallback) (CURL *easy,
                          const struct curl_khkey *knownkey,
                          const struct curl_khkey *foundkey,
                          enum curl_khmatch,
                          void *clientp);


typedef enum {
  CURLUSESSL_NONE,
  CURLUSESSL_TRY,
  CURLUSESSL_CONTROL,
  CURLUSESSL_ALL,
  CURLUSESSL_LAST
} curl_usessl;
typedef enum {
  CURLFTPSSL_CCC_NONE,
  CURLFTPSSL_CCC_PASSIVE,
  CURLFTPSSL_CCC_ACTIVE,
  CURLFTPSSL_CCC_LAST
} curl_ftpccc;


typedef enum {
  CURLFTPAUTH_DEFAULT,
  CURLFTPAUTH_SSL,
  CURLFTPAUTH_TLS,
  CURLFTPAUTH_LAST
} curl_ftpauth;


typedef enum {
  CURLFTP_CREATE_DIR_NONE,
  CURLFTP_CREATE_DIR,


  CURLFTP_CREATE_DIR_RETRY,

  CURLFTP_CREATE_DIR_LAST
} curl_ftpcreatedir;


typedef enum {
  CURLFTPMETHOD_DEFAULT,
  CURLFTPMETHOD_MULTICWD,
  CURLFTPMETHOD_NOCWD,
  CURLFTPMETHOD_SINGLECWD,
  CURLFTPMETHOD_LAST
} curl_ftpmethod;
typedef enum {

  CURLOPT_ WRITEDATA = 10000 + 1,


  CURLOPT_ URL = 10000 + 2,


  CURLOPT_ PORT = 0 + 3,


  CURLOPT_ PROXY = 10000 + 4,


  CURLOPT_ USERPWD = 10000 + 5,


  CURLOPT_ PROXYUSERPWD = 10000 + 6,


  CURLOPT_ RANGE = 10000 + 7,




  CURLOPT_ READDATA = 10000 + 9,



  CURLOPT_ ERRORBUFFER = 10000 + 10,



  CURLOPT_ WRITEFUNCTION = 20000 + 11,



  CURLOPT_ READFUNCTION = 20000 + 12,


  CURLOPT_ TIMEOUT = 0 + 13,
  CURLOPT_ INFILESIZE = 0 + 14,


  CURLOPT_ POSTFIELDS = 10000 + 15,


  CURLOPT_ REFERER = 10000 + 16,



  CURLOPT_ FTPPORT = 10000 + 17,


  CURLOPT_ USERAGENT = 10000 + 18,
  CURLOPT_ LOW_SPEED_LIMIT = 0 + 19,


  CURLOPT_ LOW_SPEED_TIME = 0 + 20,







  CURLOPT_ RESUME_FROM = 0 + 21,


  CURLOPT_ COOKIE = 10000 + 22,



  CURLOPT_ HTTPHEADER = 10000 + 23,


  CURLOPT_ HTTPPOST = 10000 + 24,


  CURLOPT_ SSLCERT = 10000 + 25,


  CURLOPT_ KEYPASSWD = 10000 + 26,


  CURLOPT_ CRLF = 0 + 27,


  CURLOPT_ QUOTE = 10000 + 28,



  CURLOPT_ HEADERDATA = 10000 + 29,



  CURLOPT_ COOKIEFILE = 10000 + 31,



  CURLOPT_ SSLVERSION = 0 + 32,


  CURLOPT_ TIMECONDITION = 0 + 33,



  CURLOPT_ TIMEVALUE = 0 + 34,







  CURLOPT_ CUSTOMREQUEST = 10000 + 36,


  CURLOPT_ STDERR = 10000 + 37,




  CURLOPT_ POSTQUOTE = 10000 + 39,

  CURLOPT_ OBSOLETE40 = 10000 + 40,

  CURLOPT_ VERBOSE = 0 + 41,
  CURLOPT_ HEADER = 0 + 42,
  CURLOPT_ NOPROGRESS = 0 + 43,
  CURLOPT_ NOBODY = 0 + 44,
  CURLOPT_ FAILONERROR = 0 + 45,
  CURLOPT_ UPLOAD = 0 + 46,
  CURLOPT_ POST = 0 + 47,
  CURLOPT_ DIRLISTONLY = 0 + 48,

  CURLOPT_ APPEND = 0 + 50,



  CURLOPT_ NETRC = 0 + 51,

  CURLOPT_ FOLLOWLOCATION = 0 + 52,

  CURLOPT_ TRANSFERTEXT = 0 + 53,
  CURLOPT_ PUT = 0 + 54,







  CURLOPT_ PROGRESSFUNCTION = 20000 + 56,



  CURLOPT_ PROGRESSDATA = 10000 + 57,



  CURLOPT_ AUTOREFERER = 0 + 58,



  CURLOPT_ PROXYPORT = 0 + 59,


  CURLOPT_ POSTFIELDSIZE = 0 + 60,


  CURLOPT_ HTTPPROXYTUNNEL = 0 + 61,


  CURLOPT_ INTERFACE = 10000 + 62,




  CURLOPT_ KRBLEVEL = 10000 + 63,


  CURLOPT_ SSL_VERIFYPEER = 0 + 64,



  CURLOPT_ CAINFO = 10000 + 65,





  CURLOPT_ MAXREDIRS = 0 + 68,



  CURLOPT_ FILETIME = 0 + 69,


  CURLOPT_ TELNETOPTIONS = 10000 + 70,


  CURLOPT_ MAXCONNECTS = 0 + 71,

  CURLOPT_ OBSOLETE72 = 0 + 72,






  CURLOPT_ FRESH_CONNECT = 0 + 74,




  CURLOPT_ FORBID_REUSE = 0 + 75,



  CURLOPT_ RANDOM_FILE = 10000 + 76,


  CURLOPT_ EGDSOCKET = 10000 + 77,



  CURLOPT_ CONNECTTIMEOUT = 0 + 78,



  CURLOPT_ HEADERFUNCTION = 20000 + 79,




  CURLOPT_ HTTPGET = 0 + 80,




  CURLOPT_ SSL_VERIFYHOST = 0 + 81,



  CURLOPT_ COOKIEJAR = 10000 + 82,


  CURLOPT_ SSL_CIPHER_LIST = 10000 + 83,



  CURLOPT_ HTTP_VERSION = 0 + 84,




  CURLOPT_ FTP_USE_EPSV = 0 + 85,


  CURLOPT_ SSLCERTTYPE = 10000 + 86,


  CURLOPT_ SSLKEY = 10000 + 87,


  CURLOPT_ SSLKEYTYPE = 10000 + 88,


  CURLOPT_ SSLENGINE = 10000 + 89,




  CURLOPT_ SSLENGINE_DEFAULT = 0 + 90,


  CURLOPT_ DNS_USE_GLOBAL_CACHE = 0 + 91,


  CURLOPT_ DNS_CACHE_TIMEOUT = 0 + 92,


  CURLOPT_ PREQUOTE = 10000 + 93,


  CURLOPT_ DEBUGFUNCTION = 20000 + 94,


  CURLOPT_ DEBUGDATA = 10000 + 95,


  CURLOPT_ COOKIESESSION = 0 + 96,



  CURLOPT_ CAPATH = 10000 + 97,


  CURLOPT_ BUFFERSIZE = 0 + 98,




  CURLOPT_ NOSIGNAL = 0 + 99,


  CURLOPT_ SHARE = 10000 + 100,




  CURLOPT_ PROXYTYPE = 0 + 101,




  CURLOPT_ ACCEPT_ENCODING = 10000 + 102,


  CURLOPT_ PRIVATE = 10000 + 103,


  CURLOPT_ HTTP200ALIASES = 10000 + 104,




  CURLOPT_ UNRESTRICTED_AUTH = 0 + 105,




  CURLOPT_ FTP_USE_EPRT = 0 + 106,




  CURLOPT_ HTTPAUTH = 0 + 107,




  CURLOPT_ SSL_CTX_FUNCTION = 20000 + 108,



  CURLOPT_ SSL_CTX_DATA = 10000 + 109,





  CURLOPT_ FTP_CREATE_MISSING_DIRS = 0 + 110,




  CURLOPT_ PROXYAUTH = 0 + 111,





  CURLOPT_ FTP_RESPONSE_TIMEOUT = 0 + 112,





  CURLOPT_ IPRESOLVE = 0 + 113,






  CURLOPT_ MAXFILESIZE = 0 + 114,




  CURLOPT_ INFILESIZE_LARGE = 30000 + 115,




  CURLOPT_ RESUME_FROM_LARGE = 30000 + 116,




  CURLOPT_ MAXFILESIZE_LARGE = 30000 + 117,





  CURLOPT_ NETRC_FILE = 10000 + 118,






  CURLOPT_ USE_SSL = 0 + 119,


  CURLOPT_ POSTFIELDSIZE_LARGE = 30000 + 120,


  CURLOPT_ TCP_NODELAY = 0 + 121,
  CURLOPT_ FTPSSLAUTH = 0 + 129,

  CURLOPT_ IOCTLFUNCTION = 20000 + 130,
  CURLOPT_ IOCTLDATA = 10000 + 131,






  CURLOPT_ FTP_ACCOUNT = 10000 + 134,


  CURLOPT_ COOKIELIST = 10000 + 135,


  CURLOPT_ IGNORE_CONTENT_LENGTH = 0 + 136,





  CURLOPT_ FTP_SKIP_PASV_IP = 0 + 137,



  CURLOPT_ FTP_FILEMETHOD = 0 + 138,


  CURLOPT_ LOCALPORT = 0 + 139,




  CURLOPT_ LOCALPORTRANGE = 0 + 140,



  CURLOPT_ CONNECT_ONLY = 0 + 141,



  CURLOPT_ CONV_FROM_NETWORK_FUNCTION = 20000 + 142,



  CURLOPT_ CONV_TO_NETWORK_FUNCTION = 20000 + 143,




  CURLOPT_ CONV_FROM_UTF8_FUNCTION = 20000 + 144,



  CURLOPT_ MAX_SEND_SPEED_LARGE = 30000 + 145,
  CURLOPT_ MAX_RECV_SPEED_LARGE = 30000 + 146,


  CURLOPT_ FTP_ALTERNATIVE_TO_USER = 10000 + 147,


  CURLOPT_ SOCKOPTFUNCTION = 20000 + 148,
  CURLOPT_ SOCKOPTDATA = 10000 + 149,



  CURLOPT_ SSL_SESSIONID_CACHE = 0 + 150,


  CURLOPT_ SSH_AUTH_TYPES = 0 + 151,


  CURLOPT_ SSH_PUBLIC_KEYFILE = 10000 + 152,
  CURLOPT_ SSH_PRIVATE_KEYFILE = 10000 + 153,


  CURLOPT_ FTP_SSL_CCC = 0 + 154,


  CURLOPT_ TIMEOUT_MS = 0 + 155,
  CURLOPT_ CONNECTTIMEOUT_MS = 0 + 156,



  CURLOPT_ HTTP_TRANSFER_DECODING = 0 + 157,
  CURLOPT_ HTTP_CONTENT_DECODING = 0 + 158,



  CURLOPT_ NEW_FILE_PERMS = 0 + 159,
  CURLOPT_ NEW_DIRECTORY_PERMS = 0 + 160,



  CURLOPT_ POSTREDIR = 0 + 161,


  CURLOPT_ SSH_HOST_PUBLIC_KEY_MD5 = 10000 + 162,





  CURLOPT_ OPENSOCKETFUNCTION = 20000 + 163,
  CURLOPT_ OPENSOCKETDATA = 10000 + 164,


  CURLOPT_ COPYPOSTFIELDS = 10000 + 165,


  CURLOPT_ PROXY_TRANSFER_MODE = 0 + 166,


  CURLOPT_ SEEKFUNCTION = 20000 + 167,
  CURLOPT_ SEEKDATA = 10000 + 168,


  CURLOPT_ CRLFILE = 10000 + 169,


  CURLOPT_ ISSUERCERT = 10000 + 170,


  CURLOPT_ ADDRESS_SCOPE = 0 + 171,



  CURLOPT_ CERTINFO = 0 + 172,


  CURLOPT_ USERNAME = 10000 + 173,
  CURLOPT_ PASSWORD = 10000 + 174,


  CURLOPT_ PROXYUSERNAME = 10000 + 175,
  CURLOPT_ PROXYPASSWORD = 10000 + 176,
  CURLOPT_ NOPROXY = 10000 + 177,


  CURLOPT_ TFTP_BLKSIZE = 0 + 178,


  CURLOPT_ SOCKS5_GSSAPI_SERVICE = 10000 + 179,


  CURLOPT_ SOCKS5_GSSAPI_NEC = 0 + 180,





  CURLOPT_ PROTOCOLS = 0 + 181,





  CURLOPT_ REDIR_PROTOCOLS = 0 + 182,


  CURLOPT_ SSH_KNOWNHOSTS = 10000 + 183,



  CURLOPT_ SSH_KEYFUNCTION = 20000 + 184,


  CURLOPT_ SSH_KEYDATA = 10000 + 185,


  CURLOPT_ MAIL_FROM = 10000 + 186,


  CURLOPT_ MAIL_RCPT = 10000 + 187,


  CURLOPT_ FTP_USE_PRET = 0 + 188,


  CURLOPT_ RTSP_REQUEST = 0 + 189,


  CURLOPT_ RTSP_SESSION_ID = 10000 + 190,


  CURLOPT_ RTSP_STREAM_URI = 10000 + 191,


  CURLOPT_ RTSP_TRANSPORT = 10000 + 192,


  CURLOPT_ RTSP_CLIENT_CSEQ = 0 + 193,


  CURLOPT_ RTSP_SERVER_CSEQ = 0 + 194,


  CURLOPT_ INTERLEAVEDATA = 10000 + 195,


  CURLOPT_ INTERLEAVEFUNCTION = 20000 + 196,


  CURLOPT_ WILDCARDMATCH = 0 + 197,



  CURLOPT_ CHUNK_BGN_FUNCTION = 20000 + 198,



  CURLOPT_ CHUNK_END_FUNCTION = 20000 + 199,


  CURLOPT_ FNMATCH_FUNCTION = 20000 + 200,


  CURLOPT_ CHUNK_DATA = 10000 + 201,


  CURLOPT_ FNMATCH_DATA = 10000 + 202,


  CURLOPT_ RESOLVE = 10000 + 203,


  CURLOPT_ TLSAUTH_USERNAME = 10000 + 204,


  CURLOPT_ TLSAUTH_PASSWORD = 10000 + 205,


  CURLOPT_ TLSAUTH_TYPE = 10000 + 206,
  CURLOPT_ TRANSFER_ENCODING = 0 + 207,



  CURLOPT_ CLOSESOCKETFUNCTION = 20000 + 208,
  CURLOPT_ CLOSESOCKETDATA = 10000 + 209,


  CURLOPT_ GSSAPI_DELEGATION = 0 + 210,


  CURLOPT_ DNS_SERVERS = 10000 + 211,



  CURLOPT_ ACCEPTTIMEOUT_MS = 0 + 212,


  CURLOPT_ TCP_KEEPALIVE = 0 + 213,


  CURLOPT_ TCP_KEEPIDLE = 0 + 214,
  CURLOPT_ TCP_KEEPINTVL = 0 + 215,


  CURLOPT_ SSL_OPTIONS = 0 + 216,


  CURLOPT_ MAIL_AUTH = 10000 + 217,


  CURLOPT_ SASL_IR = 0 + 218,




  CURLOPT_ XFERINFOFUNCTION = 20000 + 219,


  CURLOPT_ XOAUTH2_BEARER = 10000 + 220,




  CURLOPT_ DNS_INTERFACE = 10000 + 221,



  CURLOPT_ DNS_LOCAL_IP4 = 10000 + 222,



  CURLOPT_ DNS_LOCAL_IP6 = 10000 + 223,


  CURLOPT_ LOGIN_OPTIONS = 10000 + 224,


  CURLOPT_ SSL_ENABLE_NPN = 0 + 225,


  CURLOPT_ SSL_ENABLE_ALPN = 0 + 226,



  CURLOPT_ EXPECT_100_TIMEOUT_MS = 0 + 227,



  CURLOPT_ PROXYHEADER = 10000 + 228,


  CURLOPT_ HEADEROPT = 0 + 229,



  CURLOPT_ PINNEDPUBLICKEY = 10000 + 230,


  CURLOPT_ UNIX_SOCKET_PATH = 10000 + 231,


  CURLOPT_ SSL_VERIFYSTATUS = 0 + 232,


  CURLOPT_ SSL_FALSESTART = 0 + 233,


  CURLOPT_ PATH_AS_IS = 0 + 234,


  CURLOPT_ PROXY_SERVICE_NAME = 10000 + 235,


  CURLOPT_ SERVICE_NAME = 10000 + 236,


  CURLOPT_ PIPEWAIT = 0 + 237,


  CURLOPT_ DEFAULT_PROTOCOL = 10000 + 238,


  CURLOPT_ STREAM_WEIGHT = 0 + 239,


  CURLOPT_ STREAM_DEPENDS = 10000 + 240,


  CURLOPT_ STREAM_DEPENDS_E = 10000 + 241,


  CURLOPT_ TFTP_NO_OPTIONS = 0 + 242,



  CURLOPT_ CONNECT_TO = 10000 + 243,


  CURLOPT_ TCP_FASTOPEN = 0 + 244,



  CURLOPT_ KEEP_SENDING_ON_ERROR = 0 + 245,



  CURLOPT_ PROXY_CAINFO = 10000 + 246,



  CURLOPT_ PROXY_CAPATH = 10000 + 247,



  CURLOPT_ PROXY_SSL_VERIFYPEER = 0 + 248,




  CURLOPT_ PROXY_SSL_VERIFYHOST = 0 + 249,



  CURLOPT_ PROXY_SSLVERSION = 0 + 250,


  CURLOPT_ PROXY_TLSAUTH_USERNAME = 10000 + 251,


  CURLOPT_ PROXY_TLSAUTH_PASSWORD = 10000 + 252,


  CURLOPT_ PROXY_TLSAUTH_TYPE = 10000 + 253,


  CURLOPT_ PROXY_SSLCERT = 10000 + 254,



  CURLOPT_ PROXY_SSLCERTTYPE = 10000 + 255,


  CURLOPT_ PROXY_SSLKEY = 10000 + 256,



  CURLOPT_ PROXY_SSLKEYTYPE = 10000 + 257,


  CURLOPT_ PROXY_KEYPASSWD = 10000 + 258,


  CURLOPT_ PROXY_SSL_CIPHER_LIST = 10000 + 259,


  CURLOPT_ PROXY_CRLFILE = 10000 + 260,



  CURLOPT_ PROXY_SSL_OPTIONS = 0 + 261,


  CURLOPT_ PRE_PROXY = 10000 + 262,



  CURLOPT_ PROXY_PINNEDPUBLICKEY = 10000 + 263,


  CURLOPT_ ABSTRACT_UNIX_SOCKET = 10000 + 264,


  CURLOPT_ SUPPRESS_CONNECT_HEADERS = 0 + 265,


  CURLOPT_ REQUEST_TARGET = 10000 + 266,


  CURLOPT_ SOCKS5_AUTH = 0 + 267,


  CURLOPT_ SSH_COMPRESSION = 0 + 268,


  CURLOPT_ MIMEPOST = 10000 + 269,



  CURLOPT_ TIMEVALUE_LARGE = 30000 + 270,


  CURLOPT_ HAPPY_EYEBALLS_TIMEOUT_MS = 0 + 271,


  CURLOPT_ RESOLVER_START_FUNCTION = 20000 + 272,


  CURLOPT_ RESOLVER_START_DATA = 10000 + 273,


  CURLOPT_ HAPROXYPROTOCOL = 0 + 274,


  CURLOPT_ DNS_SHUFFLE_ADDRESSES = 0 + 275,


  CURLOPT_ TLS13_CIPHERS = 10000 + 276,
  CURLOPT_ PROXY_TLS13_CIPHERS = 10000 + 277,


  CURLOPT_ DISALLOW_USERNAME_IN_URL = 0 + 278,


  CURLOPT_ DOH_URL = 10000 + 279,


  CURLOPT_ UPLOAD_BUFFERSIZE = 0 + 280,


  CURLOPT_ UPKEEP_INTERVAL_MS = 0 + 281,


  CURLOPT_ CURLU = 10000 + 282,


  CURLOPT_ TRAILERFUNCTION = 20000 + 283,


  CURLOPT_ TRAILERDATA = 10000 + 284,


  CURLOPT_ HTTP09_ALLOWED = 0 + 285,


  CURLOPT_ ALTSVC_CTRL = 0 + 286,


  CURLOPT_ ALTSVC = 10000 + 287,

  CURLOPT_LASTENTRY
} CURLoption;
enum {
  CURL_HTTP_VERSION_NONE,


  CURL_HTTP_VERSION_1_0,
  CURL_HTTP_VERSION_1_1,
  CURL_HTTP_VERSION_2_0,
  CURL_HTTP_VERSION_2TLS,
  CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE,


  CURL_HTTP_VERSION_LAST
};
enum {
    CURL_RTSPREQ_NONE,
    CURL_RTSPREQ_OPTIONS,
    CURL_RTSPREQ_DESCRIBE,
    CURL_RTSPREQ_ANNOUNCE,
    CURL_RTSPREQ_SETUP,
    CURL_RTSPREQ_PLAY,
    CURL_RTSPREQ_PAUSE,
    CURL_RTSPREQ_TEARDOWN,
    CURL_RTSPREQ_GET_PARAMETER,
    CURL_RTSPREQ_SET_PARAMETER,
    CURL_RTSPREQ_RECORD,
    CURL_RTSPREQ_RECEIVE,
    CURL_RTSPREQ_LAST
};


enum CURL_NETRC_OPTION {
  CURL_NETRC_IGNORED,

  CURL_NETRC_OPTIONAL,

  CURL_NETRC_REQUIRED,


  CURL_NETRC_LAST
};

enum {
  CURL_SSLVERSION_DEFAULT,
  CURL_SSLVERSION_TLSv1,
  CURL_SSLVERSION_SSLv2,
  CURL_SSLVERSION_SSLv3,
  CURL_SSLVERSION_TLSv1_0,
  CURL_SSLVERSION_TLSv1_1,
  CURL_SSLVERSION_TLSv1_2,
  CURL_SSLVERSION_TLSv1_3,

  CURL_SSLVERSION_LAST
};

enum {
  CURL_SSLVERSION_MAX_NONE = 0,
  CURL_SSLVERSION_MAX_DEFAULT = (CURL_SSLVERSION_TLSv1 << 16),
  CURL_SSLVERSION_MAX_TLSv1_0 = (CURL_SSLVERSION_TLSv1_0 << 16),
  CURL_SSLVERSION_MAX_TLSv1_1 = (CURL_SSLVERSION_TLSv1_1 << 16),
  CURL_SSLVERSION_MAX_TLSv1_2 = (CURL_SSLVERSION_TLSv1_2 << 16),
  CURL_SSLVERSION_MAX_TLSv1_3 = (CURL_SSLVERSION_TLSv1_3 << 16),


  CURL_SSLVERSION_MAX_LAST = (CURL_SSLVERSION_LAST << 16)
};

enum CURL_TLSAUTH {
  CURL_TLSAUTH_NONE,
  CURL_TLSAUTH_SRP,
  CURL_TLSAUTH_LAST
};
typedef enum {
  CURL_TIMECOND_NONE,

  CURL_TIMECOND_IFMODSINCE,
  CURL_TIMECOND_IFUNMODSINCE,
  CURL_TIMECOND_LASTMOD,

  CURL_TIMECOND_LAST
} curl_TimeCond;






            int curl_strequal(const char *s1, const char *s2);
            int curl_strnequal(const char *s1, const char *s2, size_t n);


typedef struct curl_mime_s curl_mime;
typedef struct curl_mimepart_s curl_mimepart;
            curl_mime *curl_mime_init(CURL *easy);
            void curl_mime_free(curl_mime *mime);
            curl_mimepart *curl_mime_addpart(curl_mime *mime);
            CURLcode curl_mime_name(curl_mimepart *part, const char *name);
            CURLcode curl_mime_filename(curl_mimepart *part,
                                        const char *filename);
            CURLcode curl_mime_type(curl_mimepart *part, const char *mimetype);
            CURLcode curl_mime_encoder(curl_mimepart *part,
                                       const char *encoding);
            CURLcode curl_mime_data(curl_mimepart *part,
                                    const char *data, size_t datasize);
            CURLcode curl_mime_filedata(curl_mimepart *part,
                                        const char *filename);
            CURLcode curl_mime_data_cb(curl_mimepart *part,
                                       curl_off_t datasize,
                                       curl_read_callback readfunc,
                                       curl_seek_callback seekfunc,
                                       curl_free_callback freefunc,
                                       void *arg);
            CURLcode curl_mime_subparts(curl_mimepart *part,
                                        curl_mime *subparts);







            CURLcode curl_mime_headers(curl_mimepart *part,
                                       struct curl_slist *headers,
                                       int take_ownership);
typedef enum {
  CURLFORM_ NOTHING,


  CURLFORM_ COPYNAME,
  CURLFORM_ PTRNAME,
  CURLFORM_ NAMELENGTH,
  CURLFORM_ COPYCONTENTS,
  CURLFORM_ PTRCONTENTS,
  CURLFORM_ CONTENTSLENGTH,
  CURLFORM_ FILECONTENT,
  CURLFORM_ ARRAY,
  CURLFORM_ OBSOLETE,
  CURLFORM_ FILE,

  CURLFORM_ BUFFER,
  CURLFORM_ BUFFERPTR,
  CURLFORM_ BUFFERLENGTH,

  CURLFORM_ CONTENTTYPE,
  CURLFORM_ CONTENTHEADER,
  CURLFORM_ FILENAME,
  CURLFORM_ END,
  CURLFORM_ OBSOLETE2,

  CURLFORM_ STREAM,
  CURLFORM_ CONTENTLEN,

  CURLFORM_LASTENTRY
} CURLformoption;




struct curl_forms {
  CURLformoption option;
  const char *value;
};
typedef enum {
  CURL_FORMADD_OK,

  CURL_FORMADD_MEMORY,
  CURL_FORMADD_OPTION_TWICE,
  CURL_FORMADD_NULL,
  CURL_FORMADD_UNKNOWN_OPTION,
  CURL_FORMADD_INCOMPLETE,
  CURL_FORMADD_ILLEGAL_ARRAY,
  CURL_FORMADD_DISABLED,

  CURL_FORMADD_LAST
} CURLFORMcode;
            CURLFORMcode curl_formadd(struct curl_httppost **httppost,
                                      struct curl_httppost **last_post,
                                      ...);
typedef size_t (*curl_formget_callback)(void *arg, const char *buf,
                                        size_t len);
            int curl_formget(struct curl_httppost *form, void *arg,
                             curl_formget_callback append);







            void curl_formfree(struct curl_httppost *form);
            char *curl_getenv(const char *variable);
            char *curl_version(void);
            char *curl_easy_escape(CURL *handle,
                                   const char *string,
                                   int length);


            char *curl_escape(const char *string,
                              int length);
            char *curl_easy_unescape(CURL *handle,
                                     const char *string,
                                     int length,
                                     int *outlength);


            char *curl_unescape(const char *string,
                                int length);
            void curl_free(void *p);
            CURLcode curl_global_init(long flags);
            CURLcode curl_global_init_mem(long flags,
                                          curl_malloc_callback m,
                                          curl_free_callback f,
                                          curl_realloc_callback r,
                                          curl_strdup_callback s,
                                          curl_calloc_callback c);
            void curl_global_cleanup(void);


struct curl_slist {
  char *data;
  struct curl_slist *next;
};
typedef struct {
  curl_sslbackend id;
  const char *name;
} curl_ssl_backend;

typedef enum {
  CURLSSLSET_OK = 0,
  CURLSSLSET_UNKNOWN_BACKEND,
  CURLSSLSET_TOO_LATE,
  CURLSSLSET_NO_BACKENDS
} CURLsslset;

            CURLsslset curl_global_sslset(curl_sslbackend id, const char *name,
                                          const curl_ssl_backend ***avail);
            struct curl_slist *curl_slist_append(struct curl_slist *,
                                                 const char *);
            void curl_slist_free_all(struct curl_slist *);
            time_t curl_getdate(const char *p, const time_t *unused);



struct curl_certinfo {
  int num_of_certs;
  struct curl_slist **certinfo;


};




struct curl_tlssessioninfo {
  curl_sslbackend backend;
  void *internals;
};
typedef enum {
  CURLINFO_NONE,
  CURLINFO_EFFECTIVE_URL = 0x100000 + 1,
  CURLINFO_RESPONSE_CODE = 0x200000 + 2,
  CURLINFO_TOTAL_TIME = 0x300000 + 3,
  CURLINFO_NAMELOOKUP_TIME = 0x300000 + 4,
  CURLINFO_CONNECT_TIME = 0x300000 + 5,
  CURLINFO_PRETRANSFER_TIME = 0x300000 + 6,
  CURLINFO_SIZE_UPLOAD = 0x300000 + 7,
  CURLINFO_SIZE_UPLOAD_T = 0x600000 + 7,
  CURLINFO_SIZE_DOWNLOAD = 0x300000 + 8,
  CURLINFO_SIZE_DOWNLOAD_T = 0x600000 + 8,
  CURLINFO_SPEED_DOWNLOAD = 0x300000 + 9,
  CURLINFO_SPEED_DOWNLOAD_T = 0x600000 + 9,
  CURLINFO_SPEED_UPLOAD = 0x300000 + 10,
  CURLINFO_SPEED_UPLOAD_T = 0x600000 + 10,
  CURLINFO_HEADER_SIZE = 0x200000 + 11,
  CURLINFO_REQUEST_SIZE = 0x200000 + 12,
  CURLINFO_SSL_VERIFYRESULT = 0x200000 + 13,
  CURLINFO_FILETIME = 0x200000 + 14,
  CURLINFO_FILETIME_T = 0x600000 + 14,
  CURLINFO_CONTENT_LENGTH_DOWNLOAD = 0x300000 + 15,
  CURLINFO_CONTENT_LENGTH_DOWNLOAD_T = 0x600000 + 15,
  CURLINFO_CONTENT_LENGTH_UPLOAD = 0x300000 + 16,
  CURLINFO_CONTENT_LENGTH_UPLOAD_T = 0x600000 + 16,
  CURLINFO_STARTTRANSFER_TIME = 0x300000 + 17,
  CURLINFO_CONTENT_TYPE = 0x100000 + 18,
  CURLINFO_REDIRECT_TIME = 0x300000 + 19,
  CURLINFO_REDIRECT_COUNT = 0x200000 + 20,
  CURLINFO_PRIVATE = 0x100000 + 21,
  CURLINFO_HTTP_CONNECTCODE = 0x200000 + 22,
  CURLINFO_HTTPAUTH_AVAIL = 0x200000 + 23,
  CURLINFO_PROXYAUTH_AVAIL = 0x200000 + 24,
  CURLINFO_OS_ERRNO = 0x200000 + 25,
  CURLINFO_NUM_CONNECTS = 0x200000 + 26,
  CURLINFO_SSL_ENGINES = 0x400000 + 27,
  CURLINFO_COOKIELIST = 0x400000 + 28,
  CURLINFO_LASTSOCKET = 0x200000 + 29,
  CURLINFO_FTP_ENTRY_PATH = 0x100000 + 30,
  CURLINFO_REDIRECT_URL = 0x100000 + 31,
  CURLINFO_PRIMARY_IP = 0x100000 + 32,
  CURLINFO_APPCONNECT_TIME = 0x300000 + 33,
  CURLINFO_CERTINFO = 0x400000 + 34,
  CURLINFO_CONDITION_UNMET = 0x200000 + 35,
  CURLINFO_RTSP_SESSION_ID = 0x100000 + 36,
  CURLINFO_RTSP_CLIENT_CSEQ = 0x200000 + 37,
  CURLINFO_RTSP_SERVER_CSEQ = 0x200000 + 38,
  CURLINFO_RTSP_CSEQ_RECV = 0x200000 + 39,
  CURLINFO_PRIMARY_PORT = 0x200000 + 40,
  CURLINFO_LOCAL_IP = 0x100000 + 41,
  CURLINFO_LOCAL_PORT = 0x200000 + 42,
  CURLINFO_TLS_SESSION = 0x400000 + 43,
  CURLINFO_ACTIVESOCKET = 0x500000 + 44,
  CURLINFO_TLS_SSL_PTR = 0x400000 + 45,
  CURLINFO_HTTP_VERSION = 0x200000 + 46,
  CURLINFO_PROXY_SSL_VERIFYRESULT = 0x200000 + 47,
  CURLINFO_PROTOCOL = 0x200000 + 48,
  CURLINFO_SCHEME = 0x100000 + 49,




  CURLINFO_TOTAL_TIME_T = 0x600000 + 50,
  CURLINFO_NAMELOOKUP_TIME_T = 0x600000 + 51,
  CURLINFO_CONNECT_TIME_T = 0x600000 + 52,
  CURLINFO_PRETRANSFER_TIME_T = 0x600000 + 53,
  CURLINFO_STARTTRANSFER_TIME_T = 0x600000 + 54,
  CURLINFO_REDIRECT_TIME_T = 0x600000 + 55,
  CURLINFO_APPCONNECT_TIME_T = 0x600000 + 56,

  CURLINFO_LASTONE = 56
} CURLINFO;





typedef enum {
  CURLCLOSEPOLICY_NONE,

  CURLCLOSEPOLICY_OLDEST,
  CURLCLOSEPOLICY_LEAST_RECENTLY_USED,
  CURLCLOSEPOLICY_LEAST_TRAFFIC,
  CURLCLOSEPOLICY_SLOWEST,
  CURLCLOSEPOLICY_CALLBACK,

  CURLCLOSEPOLICY_LAST
} curl_closepolicy;
typedef enum {
  CURL_LOCK_DATA_NONE = 0,




  CURL_LOCK_DATA_SHARE,
  CURL_LOCK_DATA_COOKIE,
  CURL_LOCK_DATA_DNS,
  CURL_LOCK_DATA_SSL_SESSION,
  CURL_LOCK_DATA_CONNECT,
  CURL_LOCK_DATA_PSL,
  CURL_LOCK_DATA_LAST
} curl_lock_data;


typedef enum {
  CURL_LOCK_ACCESS_NONE = 0,
  CURL_LOCK_ACCESS_SHARED = 1,
  CURL_LOCK_ACCESS_SINGLE = 2,
  CURL_LOCK_ACCESS_LAST
} curl_lock_access;

typedef void (*curl_lock_function)(CURL *handle,
                                   curl_lock_data data,
                                   curl_lock_access locktype,
                                   void *userptr);
typedef void (*curl_unlock_function)(CURL *handle,
                                     curl_lock_data data,
                                     void *userptr);


typedef enum {
  CURLSHE_OK,
  CURLSHE_BAD_OPTION,
  CURLSHE_IN_USE,
  CURLSHE_INVALID,
  CURLSHE_NOMEM,
  CURLSHE_NOT_BUILT_IN,
  CURLSHE_LAST
} CURLSHcode;

typedef enum {
  CURLSHOPT_NONE,
  CURLSHOPT_SHARE,
  CURLSHOPT_UNSHARE,
  CURLSHOPT_LOCKFUNC,
  CURLSHOPT_UNLOCKFUNC,
  CURLSHOPT_USERDATA,

  CURLSHOPT_LAST
} CURLSHoption;

            CURLSH *curl_share_init(void);
            CURLSHcode curl_share_setopt(CURLSH *, CURLSHoption option, ...);
            CURLSHcode curl_share_cleanup(CURLSH *);





typedef enum {
  CURLVERSION_FIRST,
  CURLVERSION_SECOND,
  CURLVERSION_THIRD,
  CURLVERSION_FOURTH,
  CURLVERSION_FIFTH,
  CURLVERSION_LAST
} CURLversion;
typedef struct {
  CURLversion age;
  const char *version;
  unsigned int version_num;
  const char *host;
  int features;
  const char *ssl_version;
  long ssl_version_num;
  const char *libz_version;

  const char * const *protocols;


  const char *ares;
  int ares_num;


  const char *libidn;




  int iconv_ver_num;

  const char *libssh_version;



  unsigned int brotli_ver_num;

  const char *brotli_version;

} curl_version_info_data;
            curl_version_info_data *curl_version_info(CURLversion);
            const char *curl_easy_strerror(CURLcode);
            const char *curl_share_strerror(CURLSHcode);
            CURLcode curl_easy_pause(CURL *handle, int bitmask);
