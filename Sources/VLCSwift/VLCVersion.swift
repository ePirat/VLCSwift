import VLCBridging

struct VLCVersion: Comparable {
    let major: Int32
    let minor: Int32
    let revision: Int32
    let extra: Int32

    public static var current: VLCVersion {
        return VLCVersion.init(
            major: LIBVLC_VERSION_MAJOR,
            minor: LIBVLC_VERSION_MINOR,
            revision: LIBVLC_VERSION_REVISION,
            extra: LIBVLC_VERSION_EXTRA)
    }

    static func < (lhs: VLCVersion, rhs: VLCVersion) -> Bool {
        let lhs_int = ((lhs.major << 24) | (lhs.minor << 16) | (lhs.revision << 8) | lhs.extra)
        let rhs_int = ((rhs.major << 24) | (rhs.minor << 16) | (rhs.revision << 8) | rhs.extra)

        return lhs_int < rhs_int
    }

    static func == (lhs: VLCVersion, rhs: VLCVersion) -> Bool {
        let lhs_int = ((lhs.major << 24) | (lhs.minor << 16) | (lhs.revision << 8) | lhs.extra)
        let rhs_int = ((rhs.major << 24) | (rhs.minor << 16) | (rhs.revision << 8) | rhs.extra)

        return lhs_int == rhs_int
    }
}
