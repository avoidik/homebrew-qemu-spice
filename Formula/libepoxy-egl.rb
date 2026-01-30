class LibepoxyEgl < Formula
  desc "Library for handling OpenGL function pointer management (with ANGLE patch applied)"
  homepage "https://github.com/anholt/libepoxy"
  head "https://github.com/anholt/libepoxy.git", branch: "master"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.10.tar.xz"
  sha256 "072cda4b59dd098bba8c2363a6247299db1fa89411dc221c8b81b8ee8192e623"
  license "MIT"

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  {
    "https://patch-diff.githubusercontent.com/raw/anholt/libepoxy/pull/311.diff" => "4fb743ec5412ab98f06e38e55ad651d7b953d052e357548c836c3578cb8eb78c",
    "https://patch-diff.githubusercontent.com/raw/anholt/libepoxy/pull/312.diff" => "22badd396a7960931e15a3fccf8d26bf422ccef16da0e70426403db32e1c99d2",
    "https://patch-diff.githubusercontent.com/raw/anholt/libepoxy/pull/314.diff" => "7aca7c2206da5aaa7f5b636f34189cb98cefee8f0608fe6b7e7c0c8aff018f5e",
  }.each do |url, sha|
    patch :p1 do
      url url
      sha256 sha
    end
  end

  conflicts_with cask: [
    "libepoxy",
  ]

  def install
    args = std_meson_args + %w[
      -Degl=yes
      -Dglx=no
      -Dx11=false
    ]
    system "meson", "setup", "build", *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <epoxy/gl.h>
      #ifdef OS_MAC
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #include <OpenGL/OpenGL.h>
      #endif
      int main()
      {
          #ifdef OS_MAC
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);
          #endif

          glClear(GL_COLOR_BUFFER_BIT);
          #ifdef OS_MAC
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          #endif
          return 0;
      }
    EOS
    args = %w[-lepoxy]
    args += %w[-framework OpenGL -DOS_MAC] if OS.mac?
    args += %w[-o test]
    system ENV.cc, "test.c", "-L#{lib}", *args
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
