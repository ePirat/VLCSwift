import VLCBridging


public typealias VLCTime = VLCBridging.libvlc_time_t

/** Opaque structure that represent a libvlc instance */
typealias CLibVLCInstance = OpaquePointer


public class VLCInstance {
    let cLibVLCPtr: CLibVLCInstance

    /**
     * Create a new VLCInstance with a `CLibVLCInstance` pointer.
     */
    init?(cPtr: CLibVLCInstance?) {
        guard let cPtr = cPtr else { return nil }
        self.cLibVLCPtr = cPtr
    }

    /**
     * Create and initialize a new VLCInstance.
     * This functions accepts an array of "command line" arguments which affect
     * the LibVLC instance default configuration.
     *
     * \note
     * LibVLC may create threads. Therefore, any thread-unsafe process
     * initialization must be performed before initializing a new LibVLC
     * instance.
     *
     * In particular and where applicable:
     *  - `setlocale()` and `textdomain()`
     *  - `setenv()`, `unsetenv()` and `putenv()`
     *  - With the X11 display system, `XInitThreads()`
     *    (see also `libvlc_media_player_set_xwindow()`)
     *  - On Microsoft Windows, `SetErrorMode()`
     *  - `sigprocmask()` shall never be invoked; `pthread_sigmask()` can be used
     *
     * On POSIX systems, the `SIGCHLD` signal <b>must not</b> be ignored, i.e. the
     * signal handler must set to `SIG_DFL` or a function pointer, not `SIG_IGN`.
     * Also while LibVLC is active, the wait() function shall not be called, and
     * any call to waitpid() shall use a strictly positive value for the first
     * parameter (i.e. the PID). Failure to follow those rules may lead to a
     * deadlock or a busy loop.
     * Also on POSIX systems, it is recommended that the SIGPIPE signal be blocked,
     * even if it is not, in principles, necessary, e.g.:
     *
     *     sigset_t set;
     *     signal(SIGCHLD, SIG_DFL);
     *     sigemptyset(&set);
     *     sigaddset(&set, SIGPIPE);
     *     pthread_sigmask(SIG_BLOCK, &set, NULL);
     *
     * On Microsoft Windows, setting the default DLL directories to SYSTEM32
     * exclusively is strongly recommended for security reasons:
     *
     *     SetDefaultDllDirectories(LOAD_LIBRARY_SEARCH_SYSTEM32);
     *
     * - Version:
     *     Arguments are meant to be passed in the same way they would be
     *     passed to VLC. The list of valid arguments depends on the LibVLC
     *     version, operating system, platform and set of available modules.
     *     Invalid or unsupported arguments will cause the initialization to
     *     fail. Also, some arguments may alter the behaviour or otherwise
     *     interfere with other LibVLC functions.
     *
     * - Warning:
     *     There is absolutely no warranty or promise of forward, backward and
     *     cross-platform compatibility with regards to the provided arguments.
     *     We recommend that you _do not use them_, other than when debugging.
     *
     * - Parameters:
     *     - arguments: The list of arguments (should be empty)
     *
     * - Returns:
     *       A new VLCInstance or nil in case of error
     */
    public convenience init?(arguments: [String] = []) {
        let argc = arguments.count

        // Convert String array to buffer of C "Strings"
        let ptr = withArrayOfCStrings(arguments) { ptr -> CLibVLCInstance? in
            return libvlc_new(Int32(argc), ptr.map(UnsafePointer.init))
        }
        self.init(cPtr: ptr)
    }

    deinit {
        libvlc_release(cLibVLCPtr)
    }

    public func setUserAgent(name: String, http: String) {
        libvlc_set_user_agent(cLibVLCPtr, name, http)
    }

    public func setAppId(id: String, version: String, icon: String) {
        libvlc_set_app_id(cLibVLCPtr, id, version, icon)
    }

    public static var version: String {
        return String.init(cString: libvlc_get_version())
    }

    public static var compiler: String {
        return String.init(cString: libvlc_get_compiler())
    }

    public static var changeset: String {
        return String.init(cString: libvlc_get_changeset())
    }
}


func withArrayOfCStrings<R>(
    _ args: [String], _ body: ([UnsafeMutablePointer<CChar>?]) -> R
    ) -> R {
    let strings = args.map {
        strdup($0)
        } + [nil]
    defer {
        strings.forEach {
            free($0)
        }
    }
    return body(strings)
}
