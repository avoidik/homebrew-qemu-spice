class SpiceServer < Formula
  desc "Spice-Server"
  homepage "https://www.spice-space.org/"
  version "0.15.2"
  url "https://gitlab.freedesktop.org/spice/spice/-/archive/v#{version}/spice-v#{version}.tar.bz2"
  sha256 "5b0a4af620565fde831eed69fc485f2aa0a01283d05d254a4c0f388128c6a162"
  head "https://gitlab.freedesktop.org/spice/spice.git", branch: "master"

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "spice-protocol" => :build

  depends_on "capstone"
  depends_on "dtc"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "snappy"
  depends_on "vde"
  depends_on "zstd"

  depends_on "opus"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "attr"
    depends_on "cairo"
    depends_on "elfutils"
    depends_on "gdk-pixbuf"
    depends_on "gtk+3"
    depends_on "libcap-ng"
    depends_on "libepoxy"
    depends_on "libx11"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "systemd"
  end

  fails_with gcc: "5"

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

end
